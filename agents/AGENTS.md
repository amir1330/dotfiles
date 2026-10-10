# Agent instructions (opencode / Codex / any coding agent)

Read `~/openspec/MEMORY.md` at the start of every session (it is the
cross-session memory). At the end of a session that changed anything
worth remembering, append an entry there (newest on top, `## YYYY-MM-DD —
topic` heading, 5–15 lines: what was done, why, files touched, open
loops). Keep entries factual and short — no chat logs.

Big planned work still goes through openspec changes (`~/openspec/changes/`,
proposal/design/tasks/specs). MEMORY.md is only the index of outcomes and
decisions, not the plan itself.

Dotfiles are managed with GNU Stow (`~/dotfiles`, one dir per package,
`stow -t ~ <packages>`). After changing stowed files run `setup-health`.
Never commit secrets. This file itself is stowed from `dotfiles/agents/`.
