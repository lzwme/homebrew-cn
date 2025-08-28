class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.8.2.tar.gz"
  sha256 "fa70e514475f2ed6ecbab307a197b3cae7c61e8e5004175bc6916556d3d0848f"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "1393944e39a33cf1c6e9baa40d488bd68834926be59a4162274d863d39d7032f"
    sha256 arm64_sonoma:  "bbb41f3ed3347777d160357274b1918eda2580835938c06df622849cbb214487"
    sha256 arm64_ventura: "cdd57adf21e0ec7bd88ef0d3614d54ab843c447a51f34e27d2cbd6014e406bb9"
    sha256 sonoma:        "31114ab73922b395398001ed22f5d2961929f69e41fa5fe9e90bf3550e2e35cc"
    sha256 ventura:       "613c7ad687ac0e6156b2c06321379f669f6a8d189363f9295385ca721b4aea08"
    sha256 arm64_linux:   "3ec2850a465da338777d462e04b66b0763e8887044a580b8293709e6e3ba6b64"
    sha256 x86_64_linux:  "946c528589d07d38b54d1c5788ec562b2e27f81d9a8672f04836b6ed56b9aa1c"
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