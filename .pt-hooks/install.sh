#!/bin/bash
# Run once after cloning: bash .pt-hooks/install.sh
git config core.hooksPath .pt-hooks
echo "✓ pt hooks activated ($(git config core.hooksPath))"
