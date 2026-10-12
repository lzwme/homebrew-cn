class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://ghfast.top/https://github.com/dprint/dprint/archive/refs/tags/0.63.0.tar.gz"
  sha256 "9e9719a43b2819f864206434feb8f3e236f7008ac461cf6cf39ef70c4197d874"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5d96ea315adc30417f1bbfe91d5cd6b254e063017055fccdabeefc0119b56202"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "431e4326894ae3b84bc48cfe295bee44c959c6753209a99cb33d6165bd052471"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a1f6226d3895348dc1f4507d2182b5b5b1e46f034637a64227c21220a022c3c8"
    sha256 cellar: :any,                 arm64_linux:       "37040743fc9cc5736b678ef2a6b26e74920906b4accb09a95310b3d34eb89f50"
    sha256 cellar: :any,                 x86_64_linux:      "3fb06c40313a96360c3fa73ea10eda140ac343c70980dbaa7679c85e9b9f69aa"
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