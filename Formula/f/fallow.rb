class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://ghfast.top/https://github.com/fallow-rs/fallow/archive/refs/tags/v3.24.0.tar.gz"
  sha256 "824590209adb36c7cafef44bdfb89ddd1f4b9808983210b19a2a2d34094e5618"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fdd2cd17827df1c4eb42ed4435ade64d427c4a540840aa690e5d043979c3fb55"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b35838c17b07d189cd6ce2b3714636ab4c49a509b70e602f0eeaf35d5cfb0b44"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41fef46b5f9fad41e0d81a92fb75ec0cb07a84475c14a129ed8e1c7ea7703e43"
    sha256 cellar: :any,                 arm64_linux:   "6506f2c194e0404cc6c2384a8e713eeeba13ee66a5748f4b153e515f1d3b3492"
    sha256 cellar: :any,                 x86_64_linux:  "4758804da0f8a92b6ab4c32d71b063ed10052245879efc1e148960f754619dea"
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