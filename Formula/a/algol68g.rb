class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.11.2.tar.gz"
  sha256 "a113b7d92b53034ea8facf5cbbb49c895ad264c41d99b770ad9fabc94c99878d"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "3d8dfff4d5ac10da0c059f6b8c6f327c246daf380c51caf253452aa44345c00e"
    sha256 arm64_sequoia: "2bcbf443faa2f13ebd65b9e6f762e0aa8cab73fae1964b72b02131392b79f366"
    sha256 arm64_sonoma:  "fa5340b090b57ac24bb982db4c20878165b694d656c85a148286d93c1194aa27"
    sha256 sonoma:        "05b1efbe06be5091c441a3899ab6a43ab542b883abc195d2df07f145d7d1ec21"
    sha256 arm64_linux:   "7520f8fd5b4de1a558edb2fc0b88a7298b407eb63b406c434df5c0e8077b3920"
    sha256 x86_64_linux:  "028b943175ecc65939dc8008c9e351c3eba8206b0a0c50cebd036be5bba6222a"
  end

  uses_from_macos "curl"
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