class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://ghproxy.com/https://github.com/dprint/dprint/archive/0.36.1.tar.gz"
  sha256 "25d4235ec08e29cdbcce81b61462a63a59e0d5c763553a8b211371ddf79765f9"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d84dc122d8a8a4fb1c1bcb68f480f2d79f8103b602a23ed986f0c55c6607a5de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "32b55986604e694441445f651a26cb76dcae48bf852869af82fd637d4d71a946"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "42d5f182e16cb8820ab51899a101e35a5d1e2722ec12a87dca06fa3bacf4447f"
    sha256 cellar: :any_skip_relocation, ventura:        "c0eaf0cb3f795d00ffccd9b57abcacde424b346ebc9c47ce1225da36761739a7"
    sha256 cellar: :any_skip_relocation, monterey:       "a2a0455c948d3479d861fa9070e9064dbc9f7f96d53d03bd6e7936cee5e9257b"
    sha256 cellar: :any_skip_relocation, big_sur:        "06d4bfd2b3632cc287b520a546c09e59b60db99cc18d09b02758e3b1eb6cd090"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23f96f8ea0f6f605c08dddc1395dc11594591c2ac5ab3f95d1994dacdbaefdfe"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/dprint")
  end

  test do
    (testpath/"dprint.json").write <<~EOS
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
    EOS

    (testpath/"test.js").write("const arr = [1,2];")
    system bin/"dprint", "fmt", testpath/"test.js"
    assert_match "const arr = [1, 2];", File.read(testpath/"test.js")

    assert_match "dprint #{version}", shell_output("#{bin}/dprint --version")
  end
end