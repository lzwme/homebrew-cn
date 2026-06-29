class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://ghfast.top/https://github.com/fallow-rs/fallow/archive/refs/tags/v2.103.0.tar.gz"
  sha256 "5dc05c411c0313a64b5b239b408d0324cf3d0600652ac2f8e6936a4595e593b9"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2cc9bc72b46548df2132b752dc392d26ae58cff2d18bc8f96a7867334dc88302"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9227ff86f4ac0010cf074576fb3efd2fd2ed4ad83de26ff735f9e340bd58a63a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "01a22552bf4d78dd15576893c04e76f8ec7c7b55965f21824365279fd2c928b1"
    sha256 cellar: :any_skip_relocation, sonoma:        "25191ce2245e16f26db2deaefd8fb6c2cdaa3153438b2c7ddd999abad88f7990"
    sha256 cellar: :any,                 arm64_linux:   "0d41cd3ebd3b0cfda21fa4f371eb878cb7be798dfb9e29f2818351e222bc07d7"
    sha256 cellar: :any,                 x86_64_linux:  "83d69c94d036d99201754677c14774a2fb27484880d2ac0f9336140f5c913436"
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