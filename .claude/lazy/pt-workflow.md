# pt Workflow — Web Package Reference

## Session
```bash
pt go                                    # start session + full sitrep
pt sitrep                                # status only (no new session)
pt in-progress                           # what's currently claimed
pt handoff "notes"                       # close session with handoff message
```

## Issues
```bash
pt issues                                # open + in-progress (default 5)
pt issues P0                             # all P0s
pt issues router                         # by component
pt issue H-001                           # full detail
pt add "Title" P0|P1|P2 comp "problem"  # create issue
pt claim H-001                           # mark in_progress before starting
pt fix H-001 "cause" "fix" "scope"      # close — scope audit REQUIRED
pt abandon H-001 "reason"               # release back to open
pt reopen H-001                          # reopen closed issue
pt search "keyword"                      # find by keyword
pt next                                  # smart triage: what to work on next
```

## Scope Audit (required for every pt fix)
```bash
pt scope-audit H-001 "pattern" src/     # validate grep scope first
# then close:
pt fix H-001 "root cause" "what changed" "grepped 'pattern' in src/, N sites in A+B, fixed all"
```

## Decisions
```bash
pt decisions                             # list active decisions
pt decision D-001                        # full detail
pt check-decision "keyword"             # search before implementing
pt add-decision "Title" comp "Rule" "Rationale"
```

## Gotchas
```bash
pt gotchas all                           # all known traps
pt gotcha add "title" comp "detail" --severity critical|warning
pt gotcha confirm G-XXX                  # confirm still relevant
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

## Orientation
```bash
pt narrative 5                           # last 5 sessions
pt hotspots                              # most-changed files (30 days)
```
