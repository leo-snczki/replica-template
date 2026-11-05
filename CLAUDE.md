# Project skills

Claude Code must run inside the devShell (`nix develop`, or direnv with
`use flake`): it links the skill into `.claude/skills/` and puts its tools
on PATH. If the skill is missing, enter the devShell and restart Claude.

- `replica-*`: clone an app end to end: recon, architecture, design,
  build, backend, tests, parity diff, user-review analysis, rebranding,
  launch listing and deploy. Use when the user wants to rebuild an
  existing app as their own product.
- Playwright: the browsers come from nixpkgs (`PLAYWRIGHT_BROWSERS_PATH`);
  install `@playwright/test@$PLAYWRIGHT_VERSION` so the versions match,
  and skip `npx playwright install`.
