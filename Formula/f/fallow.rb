class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://ghfast.top/https://github.com/fallow-rs/fallow/archive/refs/tags/v3.15.0.tar.gz"
  sha256 "aa9a2e9beed37b5fb0e51710e5c0f5e898d913ac633fea6ae37ab21e5abc752c"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e9878d8c300474893e4ddd50dc7e08692640919b0f5224d39e20833797940386"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25ab5c824537b5eea46497f16f604bbbb33f3e360e29398123680243ffeee9cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17283706e98c10008b56c6c09b75feafb6222df3849261e828871eac3985ef0a"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9dd606fb0caa7a898a3111ab62415f96f03911a63ab0541820eaaf14e2e0c75"
    sha256 cellar: :any,                 arm64_linux:   "33f398f90a6290ffdfa57405c84b92411f1b0644cafba57ba2940548f4425370"
    sha256 cellar: :any,                 x86_64_linux:  "5fec7494dc0564a8e6cd007107d2cf70a0a21540dc780688c636c2f11e98a835"
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