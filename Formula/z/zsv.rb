class Zsv < Formula
  desc "Tabular data swiss-army knife CLI"
  homepage "https://github.com/liquidaty/zsv"
  url "https://ghfast.top/https://github.com/liquidaty/zsv/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "aba51a56fd7411c12f63f2bcf197fedb1461ce799719891f0dec3df526cd815c"
  license "MIT"
  head "https://github.com/liquidaty/zsv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e16be4569c2e5a07d5f451a155d0a2a96a59297e9c731d106d12790f4be9d1f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "640bf2ddb164c61a144c1b95b0725f6c9b666d52ad4f13639c9ec7471919eac4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7fa2b80eb92262764d5471e1957ef9a557a3363bce1fb54d258bde8f7df3d0ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "02f65be5bcd67699978b3f1b3839e566d510c27d422b8d4ae445a2f566296393"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c159fc51186d69637db90f996a587a0dcc1ed104643ff0e339939b405c88bbea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d796c1abe219e1f2274271fd49d2e8eb73b80e7e835684fd1b6ee69201558ae"
  end

  depends_on "jq"

  uses_from_macos "ncurses"

  def install
    system "./configure", *std_configure_args

    ENV.deparallelize
    system "make", "install", "VERSION=#{version}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zsv version")

    input = <<~CSV
      a,b,c
      1,2,3
    CSV
    assert_equal "1", pipe_output("#{bin}/zsv count", input).strip
  end
end