# Prepare the trampoline data for the dashboard.
# Run once on your computer. It reads the yearly NEISS files (2019-2024),
# keeps the trampoline cases (product code 1233), adds readable labels,
# and saves a small file trampoline.rds that the dashboard reads.
#
# Download the yearly files from the NEISS home page, e.g.
# https://www.cpsc.gov/cgibin/NEISSQuery/Data/Archived%20Data/2024/neiss2024.tsv

library(tidyverse)

raw_dir <- "neiss_raw"   # folder with neiss2019.tsv ... neiss2024.tsv
args <- commandArgs(trailingOnly = TRUE)
if (length(args) > 0) raw_dir <- args[1]

files <- file.path(raw_dir, paste0("neiss", 2019:2024, ".tsv"))

# Read only the columns we need, all as character first (safer), then convert
keep <- c("CPSC_Case_Number", "Treatment_Date", "Age", "Sex", "Body_Part",
          "Diagnosis", "Disposition", "Location", "Product_1", "Product_2",
          "Product_3", "Narrative_1", "Weight")

read_one <- function(f) {
  # The header names are wrapped in quotes in the CPSC files; remove them
  read_tsv(f, col_types = cols(.default = "c"), quote = "",
           progress = FALSE) %>%
    rename_with(~ str_remove_all(.x, '"')) %>%
    select(all_of(keep)) %>%
    filter(Product_1 == "1233" | Product_2 == "1233" | Product_3 == "1233")
}

tramp <- map_dfr(files, read_one)

# ---- Lookup tables from the NEISS Coding Manual -----------------------------
sex_lab <- c("0" = "Not recorded", "1" = "Male", "2" = "Female",
             "3" = "Non-binary/Other")

disp_lab <- c("1" = "Treated and released", "2" = "Transferred",
              "4" = "Admitted", "5" = "Held for observation",
              "6" = "Left without being seen", "8" = "Died",
              "9" = "Not recorded")

loc_lab <- c("0" = "Not recorded", "1" = "Home", "2" = "Farm/ranch",
             "4" = "Street", "5" = "Public property",
             "6" = "Mobile/manufactured home", "7" = "Industrial",
             "8" = "School", "9" = "Sports/recreation place")

body_lab <- c("0" = "Internal", "30" = "Shoulder", "31" = "Upper trunk",
              "32" = "Elbow", "33" = "Lower arm", "34" = "Wrist",
              "35" = "Knee", "36" = "Lower leg", "37" = "Ankle",
              "38" = "Pubic region", "75" = "Head", "76" = "Face",
              "77" = "Eyeball", "79" = "Lower trunk", "80" = "Upper arm",
              "81" = "Upper leg", "82" = "Hand", "83" = "Foot",
              "84" = "25-50% of body", "85" = "All parts of body",
              "87" = "Not recorded", "88" = "Mouth", "89" = "Neck",
              "92" = "Finger", "93" = "Toe", "94" = "Ear")

diag_lab <- c("52" = "Concussion", "53" = "Contusion/abrasion",
              "54" = "Crushing", "55" = "Dislocation", "57" = "Fracture",
              "58" = "Hematoma", "59" = "Laceration", "60" = "Dental injury",
              "61" = "Nerve damage", "62" = "Internal organ injury",
              "63" = "Puncture", "64" = "Strain/sprain",
              "66" = "Hemorrhage", "71" = "Other/not stated",
              "72" = "Avulsion")

# Body region: groups body parts so plots stay readable
region_of <- function(bp) case_when(
  bp %in% c("Head", "Face", "Eyeball", "Mouth", "Ear", "Neck") ~ "Head & neck",
  bp %in% c("Shoulder", "Upper arm", "Elbow", "Lower arm", "Wrist",
            "Hand", "Finger") ~ "Arm & hand",
  bp %in% c("Upper leg", "Knee", "Lower leg", "Ankle", "Foot",
            "Toe") ~ "Leg & foot",
  bp %in% c("Upper trunk", "Lower trunk", "Pubic region",
            "Internal") ~ "Trunk",
  TRUE ~ "Other/not recorded")

# How the injury happened, from the narrative (rule-based, checked by reading
# a sample of narratives; the order of the rules matters)
mechanism_of <- function(txt) {
  t <- str_to_upper(txt)
  case_when(
    str_detect(t, "FLIP|BACKFLIP|FRONTFLIP|SOMERSAULT|BACK ?HANDSPRING") ~ "Flip or stunt",
    str_detect(t, paste0(
      "COLLIDED|COLLISION|ANOTHER|BUMPED HEADS|HIT HEADS|SIBLING|BROTHER|",
      "SISTER|COUSIN|FRIEND|DOUBLE[ -]?BOUNC|DOUBLE[ -]?JUMP|",
      "LANDED ON (HIM|HER)|JUMPED ON (HIM|HER|PT)|FELL ON (HIM|HER|PT)"
    )) ~ "Multiple jumpers",
    str_detect(t, paste0(
      "FELL OFF|FALL OFF|FELL OUT|FALL OUT|FELL FROM|FELL THROUGH|",
      "ONTO (THE )?(GROUND|GRASS|CONCRETE|FLOOR)|OFF (OF )?(THE |A )?TRAMP"
    )) ~ "Fall off the trampoline",
    str_detect(t, "SPRING|FRAME|POLE|NET|METAL|BAR\\b|EDGE") ~ "Hit springs/frame/net",
    str_detect(t, "LANDED|LANDING|TWIST|ROLLED|INVERTED|AWKWARD|WRONG") ~ "Bad landing",
    str_detect(t, "FELL|FALL") ~ "Fell (no detail)",
    TRUE ~ "Not described")
}

age_group_of <- function(a) cut(a, breaks = c(-Inf, 2, 5, 11, 17, 34, Inf),
  labels = c("0-2", "3-5", "6-11", "12-17", "18-34", "35+"))

tramp <- tramp %>%
  transmute(
    case     = CPSC_Case_Number,
    date     = mdy(Treatment_Date),
    year     = year(date),
    month    = month(date, label = TRUE),
    age_code = as.integer(Age),
    # Ages 201-223 are infants: 2xx = (xx) months. 0 = not recorded.
    age      = case_when(age_code == 0 ~ NA_real_,
                         age_code > 200 ~ (age_code - 200) / 12,
                         TRUE ~ age_code),
    age_group = age_group_of(age),
    sex      = unname(sex_lab[Sex]),
    body_part = coalesce(unname(body_lab[Body_Part]), "Other"),
    region   = region_of(body_part),
    diagnosis = coalesce(unname(diag_lab[Diagnosis]), "Other"),
    disposition = unname(disp_lab[Disposition]),
    serious  = Disposition %in% c("2", "4", "8"),   # transferred, admitted, died
    location = unname(loc_lab[Location]),
    # About 45% of locations are not recorded; we keep them as their own group
    place    = case_when(location == "Home" ~ "Home",
                         location == "Sports/recreation place" ~ "Trampoline park/rec place",
                         TRUE ~ "Other/not recorded"),
    mechanism = mechanism_of(Narrative_1),
    narrative = Narrative_1,
    weight   = as.numeric(Weight)
  ) %>%
  filter(year %in% 2019:2024)

write_rds(tramp, "trampoline.rds", compress = "xz")

cat("Cases:", nrow(tramp), " National estimate:", round(sum(tramp$weight)), "\n")
