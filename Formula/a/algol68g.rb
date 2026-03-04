class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.10.11.tar.gz"
  sha256 "2012febaaa963602fc4f7a6ec5f66df3ec5be0ee3f90e201cd28b78b7238b580"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "802178581310747d9b98e70b41374c4f033857fd373e95e70d2b2d19dc6a3643"
    sha256 arm64_sequoia: "bd176b69a82c9d06cdae481cfd0dd31c8c613f232eca4f96fb7acac4d8a5637d"
    sha256 arm64_sonoma:  "000e95f394c400b9496c62b06eddcab9d9fc940530d74f40ec07a2d48b03651d"
    sha256 sonoma:        "a4ca66732422919c78025ada490ca6f229f43c3db6b061adf306b635fa996593"
    sha256 arm64_linux:   "7817f8703a8b94a3ade89831fecd0603a8e7881e39ad2f595355ba830e474b41"
    sha256 x86_64_linux:  "b0da682101ca1070dae71eccd0b23dd1a4e53d590426e2a2c75620dbd54cda94"
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