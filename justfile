check:
    cargo check --workspace --all-targets

check-fmt:
    cargo fmt --all -- --check

clippy:
    cargo clippy --workspace --all-targets --all-features --  -D warnings -W clippy::all

test:
    cargo test --workspace --all-targets --all-features

qa: check check-fmt clippy test

fmt:
    cargo fmt --all

sort:
	cargo sort --grouped .

clippy-fix:
    cargo clippy --fix --workspace --all-targets --all-features --allow-dirty --allow-staged

fix: fmt sort clippy-fix

update:
    cargo update

commit message: fix qa
    git add -A
    git commit -am "{{ message }}"

deploy name="plabayo": qa
    cargo shuttle deploy --name {{name}} --no-test

watch name="plabayo":
    cargo watch -x 'shuttle run --name {{name}}' -i 'Cargo.lock'

restart name="plabayo":
    cargo shuttle project restart --name {{name}}

shuttle-update:
    curl -sSfL https://www.shuttle.rs/install | bash
