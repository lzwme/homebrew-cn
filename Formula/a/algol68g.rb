class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.7.3.tar.gz"
  sha256 "42abcbf55f136f087ea5a7a2313ee4fcebe8c1899f274130050f1097f6cdc71c"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "7c244673f673674c7df5f7201d5fcd6545e33ef89caa5007d927c5c71403ca83"
    sha256 arm64_sonoma:  "22b478c1cbe2626431e9e6be1912d4accb3d0139223960a927688d8c8733c6bc"
    sha256 arm64_ventura: "39f2f31493057fa0530c58670566c265af3301fa77c0ad5a5a16669e948d08d2"
    sha256 sonoma:        "258df94a4d2ccdf98518fe7c3079223482f1c21b456761f6127681295aa5be7c"
    sha256 ventura:       "4c6a34b6a92e3d6d250a15706315009f49679c3d89587ab52aaf8fbd67c3ba31"
    sha256 arm64_linux:   "7d20bcc688f843bfe95fbc6eeb22b4e548210f6f4600e6fc412018fe7f0c6c25"
    sha256 x86_64_linux:  "c6e4ffe3ce303b96a339c5133051e2f783a72f0110341acb1f056a7fdda12aa5"
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