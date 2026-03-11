class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://ghfast.top/https://github.com/dprint/dprint/archive/refs/tags/0.52.1.tar.gz"
  sha256 "e6720a18b5ddbc64524e9315c2dd27af674b2f23a313043adfb258111554ce7e"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e54e04c46b3d33ec56b6ea2e4aa43d3493bec50d6ffe48c45a9235d042611a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9693d05e96acfbf522ef278ee07b34184311cd8cec6092fdfdbd9ff081512008"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c5a88a14d1e4ac626ccb93a6dff123df9126951b7884b1cdd32714888b60f3f"
    sha256 cellar: :any_skip_relocation, sonoma:        "ccc7d2f07e87722ea32ef1a69bb18482d929bb6e9037724448c82b2b821d8dd2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3dab5c41ac589a9c7cc25cb2f8ce16e8162d1acfbdfb0e73bc8a3b1e0a79aff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2fd2e05a6132fdce6853ce40cafa97b3740c855c842e602912c85bf9d18e872d"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "xz" # required for lzma support

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