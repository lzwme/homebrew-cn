class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.5.5.tar.gz"
  sha256 "d20657f0882242daf1dc258826a64ae62c35d20170a514dbcc850a3df2cae717"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "1f2f069a3d64a3bbad2c71ccf19f63b6cfd5cde7e96468a18408d855a4645aad"
    sha256 arm64_ventura:  "0a24bff45d99528fa2e706ccbe05444b5527b6a13dd21db105d3c02ca5105ab5"
    sha256 arm64_monterey: "463f7fc0f02ae828105cf42a493c23b6cb20a2c813c2ac74a279365e079780a1"
    sha256 sonoma:         "4d8d1a0e13f10095d633516660a55772f471b6a2d2505a17fc37af725c965e55"
    sha256 ventura:        "05a01d6c5b6d1e85d9aa95d46ad3cfe78bcc169c1f0f73facbd70476f805f9fc"
    sha256 monterey:       "3dbf8b8a14363e998bdb9499d5923dcd34b69cd0c76519035a2ef8f4ff1568e0"
    sha256 x86_64_linux:   "310dd5f3e59efc014f0d83cc8d4302e271c6b741329e13d265d514e18097d109"
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