# pt Workflow — Web Package Reference

## Session
```bash
pt go                                    # start session + full sitrep
pt orient                                # cold-start orientation (no session)
pt sitrep                                # status only (no new session)
pt context                               # ultra-compact dashboard (no session needed)
pt in-progress                           # what's currently claimed
pt done S-XXX success "done" "next"     # close session
```

## Navigation & Investigation
```bash
pt issue-map                             # ★ START HERE — priority×component matrix
pt trail H-001                           # full provenance: history, attempts, decisions, git
pt related H-001                         # component lens: siblings, decisions, gotchas
pt search "keyword"                      # FTS across all tables
pt since S-NNN                           # catch-up: everything changed since that session
pt narrative 5                           # last 5 sessions
pt hotspots                              # most-changed files (30 days)
```

## Issues
```bash
pt issues P0                             # all P0s (NEVER bare `pt issues`)
pt issues router                         # by component
pt issues P2 middleware                  # P2 middleware issues
pt issue H-001                           # full detail
pt add "Title" P0|P1|P2 comp "problem"  # create issue
pt claim H-001                           # mark in_progress before starting
pt fix H-001 "cause" "fix" "scope"      # close — scope audit REQUIRED
pt abandon H-001 "reason"               # release back to open
pt reopen H-001                          # reopen closed issue
pt next                                  # smart triage: what to work on next
```

## Scope Audit (required for every pt fix)
```bash
grep -rn "broken_pattern" src/
pt fix H-001 "root cause" "what changed" "grepped 'pattern' in src/, N sites in A+B, fixed all"
```

## Decisions
```bash
pt decisions CORE                        # CORE decisions (load every session)
pt decision D-001                        # full detail
pt check-decision "keyword"             # search before implementing
pt decide "Title" comp "Rule" "Why"     # add new decision
```

## Gotchas
```bash
pt gotchas all                           # all known traps
pt gotcha add "title" comp "detail" --severity critical|warning
pt gotcha confirm G-XXX                  # confirm still relevant
pt gotcha resolve G-XXX "reason"
```

## Attempts (log dead ends)
```bash
pt tried H-XXX "approach" "what happened"
pt attempts H-XXX                        # see what's been tried
```

## Todos (cross-session)
```bash
pt todos                                 # list
pt todo add "title" ["detail"] [P1]
pt todo done T-XXX
```
