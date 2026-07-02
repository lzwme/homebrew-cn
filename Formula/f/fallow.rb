class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://ghfast.top/https://github.com/fallow-rs/fallow/archive/refs/tags/v2.104.0.tar.gz"
  sha256 "9410df6c29770dd9d24af56b10b3b8c223a99b92c17888d36a19fecd93635a85"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "910a1a2ae3411f4ed15af8c9a4fab3c6887284874f4cfc217288294d26dc4218"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8384e415f53dfc9deae19c893f61844f4c9f84b4fe1b8faa30a7a9be758a9eca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3a0326fa06326f12419747a52514719c38c328b140d513b20ea78144b408140"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ceb08586e345667e93cc585632d9a53301745cd93b4ddb3ec38f670aeb5c1ab"
    sha256 cellar: :any,                 arm64_linux:   "082d2644a24770f2d1de92def6b02fb5e487965142bda183888ad8877f921d4f"
    sha256 cellar: :any,                 x86_64_linux:  "4f1dbed9a8d8c72c8f58fc01013972c2b319fdad604bd488e33dd0f3808c52d4"
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