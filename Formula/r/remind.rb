class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-06.01.00.tar.gz"
  sha256 "7f10ce82be9b2ed413984c96bca1d402a8d803b499bbc93eebd5b7af4fcb4ea3"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sequoia: "77f4937da09316b91adb9efdce5cbb7f2de7d0433dc4f7da79e5b02ff0dc4b26"
    sha256 arm64_sonoma:  "63e46d247850d1aff8864ea432b628e13e672ed582eb5cbf48ec39b528f4b3c8"
    sha256 arm64_ventura: "a23db986dfba21f12aa9b8b02b3fd14cd736dda3301e2983dcace5e133eff004"
    sha256 sonoma:        "2c3159efbdcc9bf091bc3ac3d6d7e5bef4312b9ed1f6932d36012f90d667d49e"
    sha256 ventura:       "4bcb994bc3087dff496d307509a67dc7746cfa25cbe781af526ed8e26cc90ec3"
    sha256 arm64_linux:   "98c0c3f7279986fb068da192e63028e9a76c2d5bd085f64cee5918e753017a07"
    sha256 x86_64_linux:  "d6860b01944b7d9e8ac89d75c6c5a837009437ae609276605240e3cf6ab5a2c9"
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