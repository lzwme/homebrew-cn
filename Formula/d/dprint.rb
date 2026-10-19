class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://ghfast.top/https://github.com/dprint/dprint/archive/refs/tags/0.64.0.tar.gz"
  sha256 "fcb00076c8dc6cce28ee5a20e0f105ee550d1b6e59521893f15a0f6309df9929"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "48a87656842532957c1502906b54603c5bace5512cb10e007e5a55935f2b1baf"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a2fbf7d7063df6ec01cc2d4620141045238183d78fb5046d97dc7480d4f0b0d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "829d6289ca299ea990cfe0333331e8943b338fee57a5e2ce35fdf7f69648864f"
    sha256 cellar: :any,                 arm64_linux:       "219265c4d02b83da9276b400ae0d5460bd8081c16e257b7bec1e352ab18ba3f3"
    sha256 cellar: :any,                 x86_64_linux:      "ce51af0bacef07cb376d74f054c7d8feef3420d0a52343e3e090fcf184d4eabe"
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