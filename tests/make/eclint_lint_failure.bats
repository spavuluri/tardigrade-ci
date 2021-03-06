#!/usr/bin/env bats

# NOTE: edit this file in an editor not configured to auto remediate
# required editor config changes (vim, nano, etc)

TEST_DIR="$(pwd)/eclint_lint_failure"

# generate a test terraform project with a nested project
function setup() {
rm -rf "$TEST_DIR"
working_dirs=("$TEST_DIR" "$TEST_DIR/nested")
for working_dir in "${working_dirs[@]}"
do

  mkdir -p "$working_dir"
  cat > "$working_dir/testfile.txt" <<"EOF"
trailing whitespace test

		indent style test

   indent size test
EOF
done

git add "$TEST_DIR/."
git commit -m 'eclint failure testing'

}

@test "eclint/lint: failure" {
  run make eclint/lint
  [ "$status" -eq 2 ]
}

function teardown() {
  git rm -r -f "$TEST_DIR"
  git reset --hard HEAD^
}
