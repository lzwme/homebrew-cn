class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.7.5.tar.gz"
  sha256 "8b54054f458d7e23466ca8e0ec6bc169382d908f88dfc47dc17db0677b798079"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "ad04a1e6510bfdbc82a08b0d8616147b0b76645725d1c689ca3cc898d98fc623"
    sha256 arm64_sonoma:  "221882bb021d4ae1bf33cb51fe95da0e46df75cc0af1498334ac01d57c159295"
    sha256 arm64_ventura: "ffedd352ac01974c79fc5d13677c8f6748c977cb729dd76a0e95a9f571e373bd"
    sha256 sonoma:        "57f1df34d10a6efc075f3933e3c3a0acaf1878e49a527a52ea00543a14153c95"
    sha256 ventura:       "5c2556c495f50fa423da78dde110cc361a01b90e030c7a3e36d9469519dfa7f3"
    sha256 arm64_linux:   "98c4cb395502b6f83c3c4d94e08df014165dddbccafb26d01ec06ab1aeb65bdc"
    sha256 x86_64_linux:  "1b009e5760bf663bd9e090c34fdaab9ea48c803d43f98874cd5f9b70dabede75"
  end

  uses_from_macos "ncurses"

  on_linux do
    depends_on "libpq"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    path = testpath/"hello.alg"
    path.write <<~EOS
      print("Hello World")
    EOS

    assert_equal "Hello World", shell_output("#{bin}/a68g #{path}").strip
  end
end