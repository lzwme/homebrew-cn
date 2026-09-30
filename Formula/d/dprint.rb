class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://ghfast.top/https://github.com/dprint/dprint/archive/refs/tags/0.58.0.tar.gz"
  sha256 "9c9b4121b7bde5d92f5c528f05641981346d00a0a4938ad0bd5dfab57ed153c9"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1ecea4b3a5929aadaab71b1c025011ff14bef31c9e17087123404873bd019f10"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3c1753a68d73ff48979135fca7162fd0189da143da8ec0d6cfe87ea09bad1924"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "79fe01b628a8861ecfb600a803591d915ea89b844ed8e3783040907ed9720323"
    sha256 cellar: :any,                 arm64_linux:       "90ffafee62054a984d644af3d3afc98d9b1695f83899a2956156c7afa5a875e9"
    sha256 cellar: :any,                 x86_64_linux:      "aad62a3c7cdb7d6fbfb69a14336b2ca1721b2729dfecf0c315578777a661036c"
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