class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.10.4.tar.gz"
  sha256 "256b16358806542525280c9987e9ad14b87af78343c92fdeffeca5149dbaa431"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "e9424fa7d4dc2dc594543db91001ad5f9361b8d18a2ccd95b787b6a123e6bf27"
    sha256 arm64_sequoia: "ba9c79209592e53a9fa0ccfea70a266e1890423ba69ddbd976d73645b48774d9"
    sha256 arm64_sonoma:  "07b7489b1be962a9342930ed62f8f0503e375a3e5a51de00238d68fa1613c21d"
    sha256 sonoma:        "ff67cffc285e76ee914bbfec78ef97958b3599e61dea85d7b353c58dc1bb366e"
    sha256 arm64_linux:   "d9cab5b67d583df85c3bc75c3ea1ba88cc5a4d3cb492e0355d2bc4a69871844a"
    sha256 x86_64_linux:  "c725f805ea5ac5d0604fafd0e18ca082108e7b1db32e3158f5981851cff242ea"
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