class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://ghfast.top/https://github.com/fallow-rs/fallow/archive/refs/tags/v3.16.0.tar.gz"
  sha256 "683ec014d833e52436735792b6c213894d5031f8324e4857cf5fce44ef1def28"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1d3e4b4abcfbe33d5c55a5090b47c6e3955828175975f10a040ad57ddbd8ea11"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c753a9f7fa7617d16f30e95acc720752de10be086cd226ad052e1d0e63c85774"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8d8ad24af4838caf51721ded0e7814fe56d7cb30b7e5d8ab26a54e467c9d4ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "1bd3f67574a44f588a5be1742559f1876b84aaaf00f4c559eed8fa9f0347d210"
    sha256 cellar: :any,                 arm64_linux:   "049f74f1462d3503c12927097534d1d80f94a68f1a6e48f670b5a9d0b7e4bdca"
    sha256 cellar: :any,                 x86_64_linux:  "0c1b5bbee3c01b61bb4006cb181a45a36c2c212a151c9ff25f98a8248120e2d8"
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