class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://ghfast.top/https://github.com/fallow-rs/fallow/archive/refs/tags/v2.88.2.tar.gz"
  sha256 "88a79a566c241629f56db369bc5dc69a869c4a85476bc9dd72fe5521f9b41656"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9bad2b4930037d217f73754bbeacea796825abf3f45284372c459ba4fd021dc2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9c437825449c1b685ac9d4b3f781899b0ee522953ad53d5b6153dd556ffe45d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c47bda977880e39a3c3e9873c39698b73273ead3d0420c6323c8d5a87daca0bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef4a0461f2e485470eb6f7db4be3c3dfa6da9d1b94b45d2f344e657cb4c3ad8b"
    sha256 cellar: :any,                 arm64_linux:   "5487ee88719a4b8911cd4a640dacbfb27ed3912de3e22e45cba59a7b55d82839"
    sha256 cellar: :any,                 x86_64_linux:  "d4c524143ab8216651e7ddcb7a9738643ee7cb442d5296ca06b8a9fe6f8f9316"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
  end

  test do
    (testpath/"package.json").write <<~JSON
      {
        "scripts": {
          "start": "node src/index.js"
        },
        "dependencies": {}
      }
    JSON

    (testpath/"node_modules").mkpath
    (testpath/"src").mkpath
    (testpath/"src/index.js").write <<~JS
      export const used = 1;
      console.log(used);
    JS
    (testpath/"src/unused.js").write <<~JS
      export const unused = 1;
    JS

    system "git", "init", "-q"

    output = JSON.parse(shell_output("#{bin}/fallow --format json --quiet --no-cache"))
    assert_equal 1, output.dig("check", "summary", "unused_files")
    assert_kind_of Hash, output.fetch("dupes")
    assert_kind_of Numeric, output.dig("health", "vital_signs", "dead_file_pct")
    assert_match version.to_s, shell_output("#{bin}/fallow --version")
  end
end