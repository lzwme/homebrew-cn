class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-05.04.02.tar.gz"
  sha256 "5872c2eea8ab8ae50fa4a70388547fafd8277ba1ce9f037317695541af055526"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sequoia: "0962d57a937bdac256bf1764d97b490268c09a262decb57e6cd14a81b91ee19d"
    sha256 arm64_sonoma:  "e81481df5bcde70591f093a571b6c635bc77d238d2ff564764b12a60f5498253"
    sha256 arm64_ventura: "d12a1be529029bc6108ef947105ff547af75a41fe6841dbc79c1e146fd52efa7"
    sha256 sonoma:        "ad10fc5456a09a38759d1501950538148d1d16716b1916d87bdd44af6f05e557"
    sha256 ventura:       "3ca454f7b1809c407dcd4308cd3e5306bf655bb5bb3d6c3c581b475ecacd4985"
    sha256 arm64_linux:   "56c998fff414d63290fd403e751c7a3d2cb030a162f613669a0d92089725802d"
    sha256 x86_64_linux:  "f0a04870eb4a393c2eefda722b06a8df234b175e8e6a6e8b1b016624a063f8ba"
  end

  conflicts_with "rem", because: "both install `rem` binaries"

  def install
    # Fix to error: unsupported option '-ffat-lto-objects' for target 'arm64-apple-darwin24.4.0'
    inreplace "configure", "-ffat-lto-objects", "" if DevelopmentTools.clang_build_version >= 1700

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"reminders.rem").write <<~REM
      SET $OnceFile "./once.timestamp"
      REM ONCE 2015-01-01 MSG Homebrew Test
    REM
    assert_equal "Reminders for Thursday, 1st January, 2015:\n\nHomebrew Test\n\n",
      shell_output("#{bin}/remind reminders.rem 2015-01-01")
  end
end