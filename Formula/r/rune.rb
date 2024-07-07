class Rune < Formula
  desc "Embeddable dynamic programming language for Rust"
  homepage "https:rune-rs.github.io"
  url "https:github.comrune-rsrunearchiverefstags0.13.3.tar.gz"
  sha256 "09da8e340d492ce70a6e191b27df5f39cf7a78d746a49919009292d96e35edb2"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comrune-rsrune.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ad313b066a564c6c0f770603155c7cff7c79aded2a3a01c75f27762477e5b0be"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "33e5def67eac492cf757888f320b33de9c838c770fa6b0d1568c73bb0163b689"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d855ec464b9378e5198f1423ff354c666678f39e3678b7ab6dfd2c8c0675ab9"
    sha256 cellar: :any_skip_relocation, sonoma:         "11175c7d0d0ffbb43e67905052ecba3ed6a5dc0a28c0bdfcf01b53744d00d901"
    sha256 cellar: :any_skip_relocation, ventura:        "37f56695fd1cc4512162785bd5f5f1d64b2dcd3f3feb5dbb3541ec8a58c313aa"
    sha256 cellar: :any_skip_relocation, monterey:       "d61cc75aa6bb415c5c44bf172dc78e198ea9ba881ae8b623814877b766de5e7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebabf1d77f15264ecabc19a44f38219bd5fa73f445b16ae182fe849c7c44c380"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cratesrune-cli")
    system "cargo", "install", *std_cargo_args(path: "cratesrune-languageserver")
  end

  test do
    (testpath"hello.rn").write <<~EOS
      pub fn main() {
        println!("Hello, world!");
      }
    EOS
    assert_match "Hello, world!", shell_output("#{bin"rune"} run #{testpath"hello.rn"}").strip
  end
end