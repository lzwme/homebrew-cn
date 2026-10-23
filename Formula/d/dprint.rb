class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://ghfast.top/https://github.com/dprint/dprint/archive/refs/tags/0.64.2.tar.gz"
  sha256 "fc23da6130683a15e260a18922868358a2b071edcc732067e61b9125c0001ca0"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "757436c5fcb45da040ebbd65b6dcdc9b9e874eefc4d3b22391ff1548f4db1a0d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "78db7250cdf276c8fd856f0441b782f1262c296706911b31e0163f8fcefc016a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bc19424f4e02cdf0264583de7ff0d500648e63f7898c53b99e2518f18410856e"
    sha256 cellar: :any,                 arm64_linux:       "5a39d0972b33cf0cb9984d937552c8a96e764717e27afe58541f28f6038773ac"
    sha256 cellar: :any,                 x86_64_linux:      "49ced4970a1bd1ca6d80f6099d755a7d0c88dfbc164ce6c81632391d7b80ef2b"
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