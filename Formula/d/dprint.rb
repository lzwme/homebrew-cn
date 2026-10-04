class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://ghfast.top/https://github.com/dprint/dprint/archive/refs/tags/0.60.1.tar.gz"
  sha256 "dcca401cb4cf479f01d77681f5570542c5ba1c61405e1ce4ca0a3117db16c5d7"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "284dfff20552eb3e917d7721682f9d9ac0b3f1f678561649b1f698f0b59d9ab4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9ca6606bf625e383b93537f7f32c36dfb2546a4f69f0d7c43c66477334425d66"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "48961d89bdaaae5bbc9b0f12f4d94acc32d354f75481097a56660900e0426f73"
    sha256 cellar: :any,                 arm64_linux:       "768ad6bfb3a15a6c1c85906b0d94cd0d430c34d9b64122116816f80733eb2114"
    sha256 cellar: :any,                 x86_64_linux:      "94824c083669505306130bd7624565417c89c07d2c674b3987d51e4aa476b102"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "xz" # required for lzma support

  # Test downloads dprint formatter plugins
  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV.append_to_rustflags "-C link-arg=-Wl,-undefined,dynamic_lookup" if OS.mac?

    system "cargo", "install", *std_cargo_args(path: "crates/dprint")
    generate_completions_from_executable(bin/"dprint", "completions")
  end

  test do
    (testpath/"dprint.json").write <<~JSON
      {
        "$schema": "https://dprint.dev/schemas/v0.json",
        "projectType": "openSource",
        "incremental": true,
        "typescript": {
        },
        "json": {
        },
        "markdown": {
        },
        "rustfmt": {
        },
        "includes": ["**/*.{ts,tsx,js,jsx,json,md,rs}"],
        "excludes": [
          "**/node_modules",
          "**/*-lock.json",
          "**/target"
        ],
        "plugins": [
          "https://plugins.dprint.dev/typescript-0.44.1.wasm",
          "https://plugins.dprint.dev/json-0.7.2.wasm",
          "https://plugins.dprint.dev/markdown-0.4.3.wasm",
          "https://plugins.dprint.dev/rustfmt-0.3.0.wasm"
        ]
      }
    JSON

    (testpath/"test.js").write("const arr = [1,2];")
    system bin/"dprint", "fmt", testpath/"test.js"
    assert_match "const arr = [1, 2];", File.read(testpath/"test.js")

    assert_match "dprint #{version}", shell_output("#{bin}/dprint --version")
  end
end