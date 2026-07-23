class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://ghfast.top/https://github.com/fallow-rs/fallow/archive/refs/tags/v3.8.0.tar.gz"
  sha256 "2b2b179cb8c117df93c6c7e8f5be3215c2a8d77431b6832641e7d3d8917b6d3b"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aacb7aa6743fcf7d7df7604e77de8361049f836269e9292b437e0643f1d2a119"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb0e8da875fccd20143af062724aab85b2f628de8d91095caac279fbe07b6cd1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55b955233ffa723943507bad79f23c0156624dcdf2d10699cbc1dd8adb100fb5"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b9f126395b8b29f53eb935b0008e693a151937879b670a3ffb2b25c6e1074c6"
    sha256 cellar: :any,                 arm64_linux:   "b48e9d144dc15d96f35b8597d99e028b327f782520a7bba90b06cc5db3049eb6"
    sha256 cellar: :any,                 x86_64_linux:  "81bdafb4ba8b1ebc2ccedd46aa2fd2b68ef55d554c02b481186f6ffa31a00bbb"
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