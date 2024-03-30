class Jnv < Formula
  desc "Interactive JSON filter using jq"
  homepage "https:github.comynqajnv"
  url "https:github.comynqajnvarchiverefstagsv0.2.1.tar.gz"
  sha256 "14d6429173cc6c9a1bca3b3aec9728716b271b249c6e6b897a81877f9fc5f6b3"
  license "MIT"
  head "https:github.comynqajnv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a05b46ae18a83df459b2686ba8cead1c9b9bc874b6faef8fda44031031e6ce49"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e402eb6f727f4e3068bebcac7a3eefc735c47b6d67e2b2237e413eb9b2661835"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5019cfae8d94c3228085fd34c1ec6b1bd940c287feeb85ef471d3c1251e33b6a"
    sha256 cellar: :any_skip_relocation, sonoma:         "1990f8187041eae24f3d29c5a250627a0e5f72d59a9704b4f53fa31427306f9c"
    sha256 cellar: :any_skip_relocation, ventura:        "1d340489455fb64bda2d9d475bcf9492a88fe7db86a05f9d0c9f061b4551eb74"
    sha256 cellar: :any_skip_relocation, monterey:       "29a30132fa4466c765a5e85d4c82cbabc9dbd276de3852e66f8ab82f55631dd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea46bfecfe7679eaf0e976c4084fceb8397d15fd4a1064be31e91863018d02c3"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "llvm" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output(bin"jnv --version")

    output = pipe_output("#{bin}jnv 2>&1", "homebrew", 1)
    assert_match "Error: expected value at line 1 column 1", output
  end
end