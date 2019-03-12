#### ingest national bracket from ESPN and clean up
espn <- read_html("http://games.espn.com/tournament-challenge-bracket/2018/en/whopickedwhom")

crowd_picks_raw <- espn %>%
  html_nodes(".percentage , .teamName") %>%
  html_text() %>%
  matrix(ncol=12, byrow=TRUE) %>%
  data.frame()

colnames(crowd_picks_raw) <- c("team", "R32", "team2", "R16", "team3", "R8", "team4", "R4", "team5", "NCG", "team6", "title")

crowd_picks <- crowd_picks_raw %>% 
  select(team, R32) %>% 
  left_join(crowd_picks_raw %>% select(team2, R16), by = c("team" = "team2")) %>% 
  left_join(crowd_picks_raw %>% select(team3, R8), by = c("team" = "team3")) %>% 
  left_join(crowd_picks_raw %>% select(team4, R4), by = c("team" = "team4")) %>% 
  left_join(crowd_picks_raw %>% select(team5, NCG), by = c("team" = "team5")) %>% 
  left_join(crowd_picks_raw %>% select(team6, title), by = c("team" = "team6"))

crowd_picks[,2:7] <- as.data.frame(apply(crowd_picks[,2:7], 2, function(y) as.numeric(gsub("%", "", y))))

crowd_picks <- crowd_picks %>%
  mutate_if(is.numeric, ~ .x/100)

