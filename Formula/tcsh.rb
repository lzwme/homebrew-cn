class Tcsh < Formula
  desc "Enhanced, fully compatible version of the Berkeley C shell"
  homepage "https://www.tcsh.org/"
  url "https://astron.com/pub/tcsh/tcsh-6.24.07.tar.gz"
  mirror "https://ftp.osuosl.org/pub/blfs/conglomeration/tcsh/tcsh-6.24.07.tar.gz"
  sha256 "74e4e9805cbd9413ed34b4ffa1d72fc8d0ef81a5b79476854091416ce9336995"
  license "BSD-3-Clause"

  livecheck do
    url "https://astron.com/pub/tcsh/"
    regex(/href=.*?tcsh[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "2d124dc18f98e916716df47bae88adff15885f4dea148af1594f92c2a28a9677"
    sha256 arm64_monterey: "7d2424abdbcfe85c840c7975b7aab8e627168dcba53b1ffb1e6d5f38227d139d"
    sha256 arm64_big_sur:  "4e00928c042d0b2fffc87cf0526d69d5bef6bae49778a8c5041dbc618fe95957"
    sha256 ventura:        "7a1ea1ed9e5ccf5c6467fb9656a178ab9bf52dcf847022cc9dddf8f4d57144cf"
    sha256 monterey:       "c4a895a5ccbe6464932de635159fbc14f23ae691f296afcf7a1d3db6bfd24531"
    sha256 big_sur:        "62e23c724b3145ca7cce1c44fc70d920ce1567df5b1a28502a889373b6d6189a"
    sha256 x86_64_linux:   "a165b195432de83858be57e5a54ba440cdea3640ba9843a710bd15b33b048135"
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