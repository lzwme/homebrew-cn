class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://ghfast.top/https://github.com/fallow-rs/fallow/archive/refs/tags/v2.75.0.tar.gz"
  sha256 "585f7ca318dc062eefb575404620fb4f117a26f9b8e327ea5605c25e8b63627a"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a1d9d7c1d9d6d7a38d1e2a2660a69230d28df7d6deb8ef98538a3d39708b02f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2187d9e0ab0b7087b4b9c536524241d8ebf4fa20d07684ca72043fee714d4e79"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0bb88644d8e63a39ccb26c2d15fab432de94bf6b47e72393a592ef306b94acf2"
    sha256 cellar: :any_skip_relocation, sonoma:        "e07f1ccd1b06a7214e11e0fb87e0b5399c933f4c849821c7f2e35b1f888aaad1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6e129c31a693fb559776d5b2b824f60eb89e8ca86749b352f4302b12076049a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afdbfe74d28e8f7bbb900f683c2080a3119cd82fcdddd524e0361bbafba71f67"
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