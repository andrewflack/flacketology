# read in common shorthand
team_shorthand <- read_csv(here("data_clean", "team_shorthand.csv"))

fte_names <- as.character(unique(fte_forecast$team))
espn_names <- as.character(unique(crowd_picks$team))

#### fuzzy match team names from espn to fivethirtyeight
fte_names <- as.character(unique(fte_forecast$team))
espn_names <- as.character(unique(crowd_picks$team))

match_results <- fuzzyMatch(fte_names, espn_names)

match_names <- data.frame(fte_names, espn_names = espn_names[as.data.frame(match_results)$match], distance = as.data.frame(match_results)$distance)

# check which names need to be changed in the crowd_picks data structure in order to match
match_names %>% filter(distance > 0) %>% arrange(desc(distance))

# make a few changes, then convert team back to factor
crowd_picks$team <- as.character(crowd_picks$team)
crowd_picks[crowd_picks$team == "Penn", "team"] <- "Pennsylvania"
crowd_picks[crowd_picks$team == "UMBC", "team"] <- "Maryland-Baltimore County"
crowd_picks[crowd_picks$team == "URI", "team"] <- "Rhode Island"
crowd_picks[crowd_picks$team == "UVA", "team"] <- "Virginia"
crowd_picks[crowd_picks$team == "TCU", "team"] <- "Texas Christian"
crowd_picks[crowd_picks$team == "UNC", "team"] <- "North Carolina"
crowd_picks[crowd_picks$team == "UNCG", "team"] <- "North Carolina-Greensboro"
crowd_picks[crowd_picks$team == "OSU", "team"] <- "Ohio State"
crowd_picks[crowd_picks$team == "NC State", "team"] <- "North Carolina State"
crowd_picks[crowd_picks$team == "Loyola-Chicago", "team"] <- "Loyola (IL)"

crowd_picks$team <- as.factor(crowd_picks$team)

# check again
fte_names <- as.character(unique(fte_forecast$team))
espn_names <- as.character(unique(crowd_picks$team))
match_results <- fuzzyMatch(fte_names, espn_names)
match_names <- data.frame(fte_names, espn_names = espn_names[as.data.frame(match_results)$match], distance = as.data.frame(match_results)$distance)
match_names %>% filter(distance > 0) %>% arrange(desc(distance))

# when satisfied, settle on one set to be the final name (in this case, ESPN)
match_names$final_name <- match_names$espn_names

fte_forecast <- fte_forecast %>%
  left_join(match_names[, c("fte_names", "final_name")], by = c("team" = "fte_names")) %>%
  select(final_name, team_region, R32, R16, R8, R4, NCG, title) %>%
  rename(team = final_name)

# tidy both data frames
crowd_picks_tidy <- crowd_picks %>% gather(round, prob, 2:7)
crowd_picks_tidy$round <- ordered(crowd_picks_tidy$round, levels = c("R32", "R16", "R8", "R4", "NCG", "title"))
# crowd_picks_tidy %>% ggplot(aes(x = round, y = prob)) + geom_line(aes(group = team))

fte_tidy <- fte_forecast %>% gather(round, prob, 2:8, -team_region)
fte_tidy$round <- ordered(fte_tidy$round, levels = c("R32", "R16", "R8", "R4", "NCG", "title"))

# combine
combined_df <- fte_tidy %>%
  left_join(crowd_picks_tidy, by = c("team", "round")) %>%
  rename(fte_prob = prob.x, crowd_prob = prob.y) %>%
  # mutate(crowd_prob = crowd_prob/100) %>%
  mutate(delta = fte_prob - crowd_prob) %>%
  arrange(delta)

# combined_df <- combined_df %>%
#   mutate(score = ifelse(round == "R32", (10*delta)*fte_prob,
#                         ifelse(round == "R16", ((10+20)*delta)*fte_prob,
#                                ifelse(round == "R8", ((10+20+40)*delta)*fte_prob,
#                                       ifelse(round == "R4", ((10+20+40+80)*delta)*fte_prob,
#                                              ifelse(round == "NCG", ((10+20+40+80+160)*delta)*fte_prob,
#                                                     ((10+20+40+80+160+320)*delta)*fte_prob)))))) %>%
#   arrange(desc(score))
# 
# write.csv(combined_df, "out.csv", row.names = FALSE)
