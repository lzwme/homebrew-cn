class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://ghfast.top/https://github.com/fallow-rs/fallow/archive/refs/tags/v3.22.0.tar.gz"
  sha256 "d9772b23c4023df2e15607a2e5b2437617bf2c49d241e1d54a808acc6903106a"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ffe420c1b38ab3fdf30ea2eb0430962bb29ae630df064aa9b1d37ffb6512970"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95e5307824ddf6a46ec82e4df1356e079782da5888f160c0106a609ba7c135a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1367c6254155b7b23659b03f2acea2d5a9046294bcc77dd855e8feede2af1bbf"
    sha256 cellar: :any,                 arm64_linux:   "f38d308b0785497267922c6695253d010888bf37639e44baad569de388e0ae6b"
    sha256 cellar: :any,                 x86_64_linux:  "995725f06c4f5001fbdaa27389dc6242715d5946f53b7eb5c9c3bf3e807cfe02"
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