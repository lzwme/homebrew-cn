class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://ghfast.top/https://github.com/fallow-rs/fallow/archive/refs/tags/v2.91.0.tar.gz"
  sha256 "aae2d34909a45aa582407333c82be326d55ba7dd29d24e41175b08b8e58cc0c7"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d6a5ac6c67106abf76415e8b0ed50943884bf6c08671e16336a043e1c9da6986"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b2cba7a1e23d1f5b9d5852e3918153ac70bee2c51ef14167a7ec808c691e0d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7bc6db2e18de697fae657ef7fafd1da1ad945bb3375c31dab6f453b83915da2e"
    sha256 cellar: :any_skip_relocation, sonoma:        "83656eb7271f21c54d8e3760cd99db63a2009cdfd40b6f486ef0b29a1af42fbe"
    sha256 cellar: :any,                 arm64_linux:   "683412a29349a766fdd7ae9441f4e7f5831d27bbb29fe672ae680540ca18cc04"
    sha256 cellar: :any,                 x86_64_linux:  "79ad8073b98f3435db932d85e9c0cfef2fef987f5fb66f7ae3247b1d0258112b"
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