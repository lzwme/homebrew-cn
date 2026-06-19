class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://ghfast.top/https://github.com/fallow-rs/fallow/archive/refs/tags/v2.99.0.tar.gz"
  sha256 "0136c5680322987af580338dd3e6d3cebf195266c65e3c53688ffbe1796dcc4c"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9eabadde5e053436f37cb94524a713b1402af6db7e30ffb756752a8bb1a60018"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "991cc2be3833f4848e100abdb09743f56716ee71b5cd019a706f3219950878b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e29c0b7cfc137ba334c346e406d80b87adc006d255638411c94614a6789a3ac4"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc08805c5c01895062491c3c1be218d838a24646b7fb47c928be94d8d13138fb"
    sha256 cellar: :any,                 arm64_linux:   "eafc92ddf74235991788539fa205206a4a47b57313ac3dd308767db95fff72a9"
    sha256 cellar: :any,                 x86_64_linux:  "3edb58565aec7df3bdf73f3af54ec3608dac2af91c75b35c2573589e654178e1"
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