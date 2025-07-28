class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.6.0.tar.gz"
  sha256 "b3c726613b277b3e0f74c85ded62148e4eaf5a915fb6e29a4e582204b41e3535"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "028763f40613d10b6ea009c984726e2d753f3cf62cb28079af265cfadce704ec"
    sha256 arm64_sonoma:  "6c8394c231f59724da96d41bdf5fa01949ebad71eea18c0872feba7a94a9020a"
    sha256 arm64_ventura: "c5b90a039e93339190dc02fa51d6eedb0780f79db9547c3795019569e7689619"
    sha256 sonoma:        "5008f6804d1d6a747b721d78353b15c2830d056d42f170e87819e566c2d2a81c"
    sha256 ventura:       "0ae2c29e2d3a8291f50f7a590e1c22ab6f671bbfb621363c2561ae5da2e7729d"
    sha256 arm64_linux:   "650a076d711c5e980d41025e31678f6c6ea76d953b42591797746a26ae9a73bc"
    sha256 x86_64_linux:  "ffc7d31c45dbd16907b67380df0246d97eeb8086550c4a0997e9b32088caa813"
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