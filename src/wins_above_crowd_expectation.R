# wins above crowd expectation
combined_df %>%
  group_by(team, team_region) %>%
  summarize(WACE = -1*sum(delta)) %>%
  ggplot(aes(x = reorder(team, WACE), y = WACE)) +
  geom_point() +
  geom_segment(aes(x = team, y = WACE, xend = team, yend = 0)) +
  coord_flip() +
  theme_minimal() +
  labs(x = NULL, y = "Wins Above Crowd Expectation") +
  facet_wrap(~team_region, scales = "free_y")

# combined_df %>%
#   group_by(team, team_region) %>%
#   ggplot(aes(x = reorder(team, score), y = score, colour = round)) +
#   geom_point() +
#   geom_segment(aes(x = team, y = score, xend = team, yend = 0, colour = round)) +
#   coord_flip() +
#   theme_minimal() +
#   labs(x = NULL, y = "Expected Points Above Crowd") +
#   facet_grid(round~team_region, scales = "free_y")

combined_df %>%
  mutate(team_round = paste0(team, " ", round)) %>%
  ggplot(aes(x = reorder(team_round, score), y = score, colour = round)) +
  geom_point() +
  geom_segment(aes(x = team_round, y = score, xend = team_round, yend = 0, colour = round)) +
  coord_flip() +
  theme_minimal() +
  facet_wrap(~team_region, scales = "free_y") +
  labs(x = NULL, y = "Expected Points Above Crowd")

ggsave("Exp Pts Above Crowd.png", width = 12, height = 20, units = "in")