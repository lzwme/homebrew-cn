class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.9.8.tar.gz"
  sha256 "0edca6aabc5e9476021092dfbbc2489f6f4f1094a233e001fd09d914e9649031"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "ace9cc95485bddee0cec8249d2e49fccaa56ac95d4a5cb178cbb77cdc0256a01"
    sha256 arm64_sequoia: "487beab56250772e07e298316f43f2db82955ee06de0e431778d47757839bcfd"
    sha256 arm64_sonoma:  "90fdefb7e1619e6381959c398ad436f0caa4ff9737d732cfacdd139972c292fc"
    sha256 sonoma:        "b4ae663e9b8b444bdc64cf38c19d7f464155c164a4eaa91e3184a3800cd2c9d9"
    sha256 arm64_linux:   "dc27361807c1288fe840cc43db9454e444b05ec74894d77b11016f458d7bb6aa"
    sha256 x86_64_linux:  "95fcf9f735b20c41caededf6b2815ef4fc08029e0b5a6770b633aea5c77411a8"
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