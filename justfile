fmt:
	cargo fmt --all

sort:
	cargo sort --workspace --grouped

lint: fmt sort

check:
	cargo check --all --all-targets

clippy:
	cargo clippy --all --all-targets

clippy-fix:
	cargo clippy --fix

typos:
	typos -w

doc:
	RUSTDOCFLAGS="-D rustdoc::broken-intra-doc-links" cargo doc --no-deps

doc-open:
	RUSTDOCFLAGS="-D rustdoc::broken-intra-doc-links" cargo doc --no-deps --open

hack:
	cargo hack check --each-feature --no-dev-deps --workspace

test:
	cargo test --workspace

test-ignored:
	cargo test --workspace -- --ignored

qa: lint check clippy doc test

qa-full: lint check clippy doc hack test test-ignored

upgrades:
    cargo upgrades

watch-docs:
	cargo watch -x doc

watch-check:
	cargo watch -x check -x test

example NAME:
		cargo run -p rama --example {{NAME}}
www *ARGS:
    RUST_LOG=debug cargo run -- -d "${PWD}/static" {{ARGS}}

watch-www *ARGS:
	RUST_LOG=debug cargo watch -x 'run -- -d "${PWD}/static" {{ARGS}}'

deploy:
    flyctl deploy
