class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://ghfast.top/https://github.com/fallow-rs/fallow/archive/refs/tags/v3.tar.gz"
  sha256 "1980f79fbfbd4ad0aa18b7420489ea54e30dec85dac37f6d23cb133e9fe3dbf6"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7ac7adb3790735c928482cbe0bfcd062d6a334514d691c6092833dea233dbc74"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e1b3f5943bdce6d747b4428716b0bb33a1eb695e900faf25343c660a0f0d105"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "191ea56ffdb7987262a79866103c3046cd8a60e5d787b85722174f80cb45d691"
    sha256 cellar: :any_skip_relocation, sonoma:        "c21ad51fdd8e653114ed81f5d72c3c3cdf49c28006e9b4313abdeb1f23e696d2"
    sha256 cellar: :any,                 arm64_linux:   "81dca97f31e4e3ba7c83207dd3e995a5d8dc2821687fc915bdf1136f1962333f"
    sha256 cellar: :any,                 x86_64_linux:  "b94130867b5dee94df914595e231a8cb6a64935b7f7c245f0905160ce085cfc5"
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