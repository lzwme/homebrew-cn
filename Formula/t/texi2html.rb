class Texi2html < Formula
  desc "Convert TeXinfo files to HTML"
  homepage "https://www.nongnu.org/texi2html/"
  url "https://download.savannah.gnu.org/releases/texi2html/texi2html-5.0.tar.gz"
  sha256 "e60edd2a9b8399ca615c6e81e06fa61946ba2f2406c76cd63eb829c91d3a3d7d"
  license "GPL-2.0-or-later"

  livecheck do
    skip "No longer developed or maintained"
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f76e24ff2903b5bc781b51c1fa641893343610b6827eed40af85063af2def71"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f76e24ff2903b5bc781b51c1fa641893343610b6827eed40af85063af2def71"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0f76e24ff2903b5bc781b51c1fa641893343610b6827eed40af85063af2def71"
    sha256 cellar: :any_skip_relocation, sonoma:        "cfe992664d07c79edc0c906993d4dea923de1ee43c431861cbea911825404e57"
    sha256 cellar: :any_skip_relocation, ventura:       "cfe992664d07c79edc0c906993d4dea923de1ee43c431861cbea911825404e57"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b6ba2c5edb099dcc8e2a36a2aeebb010cd55458c55e14ba84c856997bb651d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef3f56a762d93771772c74dc8469edc8caa802df76d9f17ea98e8db7a2ccfe35"
  end

  on_macos do
    depends_on "gettext"
  end

  def install
    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", "--mandir=#{man}", "--infodir=#{info}", *args, *std_configure_args
    chmod 0755, "./install-sh"
    system "make", "install"
  end

  test do
    (testpath/"test.texinfo").write <<~EOS
      @ifnottex
      @node Top
      @top Hello World!
      @end ifnottex
      @bye
    EOS
    system bin/"texi2html", "test.texinfo"
    assert_match "Hello World!", File.read("test.html")
  end
end