class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://ghfast.top/https://github.com/fallow-rs/fallow/archive/refs/tags/v3.10.0.tar.gz"
  sha256 "7e08c87cfb664d561c14a657c8b1db293c10e101b6c7ea52262c49c41b69eef2"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "48940446494338d7197ea7161ed30079506b2a4249ff563e7ddefa7b113870a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93dce405c7d1d1cf096e3e6449f5f798b29310ea45ae554aff947449ad78349c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2bebc5e1110d8e9027a4bada33a012c7bfe70996a3972e39d4edf9679bd49a21"
    sha256 cellar: :any_skip_relocation, sonoma:        "d41310061348930d982d094927d7e80ad0d457947f1ff2d8860b27e529bdc7f1"
    sha256 cellar: :any,                 arm64_linux:   "9c1df06af32eb84e9164230988019bfdbe6fa95d4e2210d63f7143a2fe9e7493"
    sha256 cellar: :any,                 x86_64_linux:  "ccbd77bbad5baa2a1de9760c9e5704e9dbf551a7a4794b50bd6584291996268c"
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