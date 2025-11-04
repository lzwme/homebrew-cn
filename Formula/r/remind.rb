class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-06.02.00.tar.gz"
  sha256 "1033b292dea080fbc162ac31c1750ead18e645d3dc5357bbb2e7dbb603b85a8d"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_tahoe:   "4f2b3d5d328a4e799c56c5191dff1924898e2e66915ee697ce7b32de7e79fb0f"
    sha256 arm64_sequoia: "8bddecb74226a01d0cac136b7bca6e800cf599e69d30c12b517fe7208215ebb2"
    sha256 arm64_sonoma:  "89bd9674a4d0af9f9154c99a9d3811e6d2a2f5617f95e61dac6f9c9af219edab"
    sha256 sonoma:        "0e123ff15d2ea3b8b6900dc9376a22288d50395fdc1bd803fb874a5207ca7918"
    sha256 arm64_linux:   "ec5beaa38a6b74594d15bd8cd82db61eb91cc3004af2eca4736a0040cc452d86"
    sha256 x86_64_linux:  "25560b44018e5eb019628b4802fff2d126062385a59443a493978725c6e6fd12"
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