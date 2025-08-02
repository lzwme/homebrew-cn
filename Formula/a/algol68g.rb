class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.6.2.tar.gz"
  sha256 "6245adf5fac6fdfc7a4c25d78d373e43c44e4c9eeee3eb5ff44fa854c9b6e551"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "bbf84ffc1774e95f88a87b7557b44b5f9ff379da0d364d600a34c82e28a420d5"
    sha256 arm64_sonoma:  "fc99046e0327b56da0b6983da0d0cea4c9709515f30db21146a335a6af2cc6bb"
    sha256 arm64_ventura: "f02e48f0f0ee17672f0a30c56327eab7cfac0c3f38cae4022e1d03fa846e3677"
    sha256 sonoma:        "7514fc0e2914eac0d0d26cf1564808b3c090513a1be249544d483b1c4881ec93"
    sha256 ventura:       "0bfef482a7809b8b866ce390285670cda31118d092bb6cc0e10c4b210ba753d6"
    sha256 arm64_linux:   "2bd8cc449a3954cddfb175ca364fe7252263c98c51f50c7b35d28939c782251c"
    sha256 x86_64_linux:  "273aac4b50350e0aa37df6bbff43c8f61ea254c608e9ec26741dc25b25f833da"
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