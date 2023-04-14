class Tcsh < Formula
  desc "Enhanced, fully compatible version of the Berkeley C shell"
  homepage "https://www.tcsh.org/"
  url "https://astron.com/pub/tcsh/tcsh-6.24.09.tar.gz"
  mirror "https://ftp.osuosl.org/pub/blfs/conglomeration/tcsh/tcsh-6.24.09.tar.gz"
  sha256 "c2e78a0c837c673410fe4b14de412bb642dc2dc61f56776e052860f82ad9eb9e"
  license "BSD-3-Clause"

  livecheck do
    url "https://astron.com/pub/tcsh/"
    regex(/href=.*?tcsh[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "72ca6bffac73495b70feb1c2be3eea5e7bd21b93901ae1630d4521ed6463d6cf"
    sha256 arm64_monterey: "421de8f04eb0175f608167f858ae253331f627b04cc006e9b084fe752870dfa9"
    sha256 arm64_big_sur:  "549f8591a79ec08202058c69c70a2b299827789cd072dfe89c923d35349e5669"
    sha256 ventura:        "1e361b5e90a52dcbb0134c67e4d439e1021b33eb6bd520b04932316c206198fa"
    sha256 monterey:       "a40b57e430e60879938cbebdad2f6012417b8bd7061a70683a4649fcfd49b40c"
    sha256 big_sur:        "61aee699e8a6575430446cbb38e144df75abea8f24729623a745dd00366c855c"
    sha256 x86_64_linux:   "a73ed771538a37573672699f98a4ff0e9fe4e3d97ba82eed2694758fd868a83a"
  end

  uses_from_macos "libxcrypt"
  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}"
    system "make", "install"
    bin.install_symlink "tcsh" => "csh"
  end

  test do
    (testpath/"test.csh").write <<~EOS
      #!#{bin}/tcsh -f
      set ARRAY=( "t" "e" "s" "t" )
      foreach i ( `seq $#ARRAY` )
        echo -n $ARRAY[$i]
      end
    EOS
    assert_equal "test", shell_output("#{bin}/tcsh ./test.csh")
  end
end