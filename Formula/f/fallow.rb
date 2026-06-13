class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://ghfast.top/https://github.com/fallow-rs/fallow/archive/refs/tags/v2.95.0.tar.gz"
  sha256 "018c597e8cf6adb6722433805c5df5ad3b5671b92a992428ea745d99fcd87175"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "81cc97310a8a34fd6f079dda2d412e541a04e8924ec1ba29290fb16e0a26f31a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8d7e536667252b1ddf23d82bf99ec56fe00309bb28f71c250ec83f592fbd4d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b8138f62815bba58d402db56653f23484b078bebb19a56129c47aa3f0b2d3c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "dc3082755cb87199a12f1b885617f589f4254c35d5384fd8e58551a804f0a738"
    sha256 cellar: :any,                 arm64_linux:   "ad86936965e2cfbd8c80cdab0659059a86951f9166f0e9e9247adfa3b3ae91aa"
    sha256 cellar: :any,                 x86_64_linux:  "58fd9ae6c3eb14c3bd55249a6c7f2e213293fbe9fc20c3315a265e9143c48304"
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