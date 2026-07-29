class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-06.02.09.tar.gz"
  sha256 "18c9b7dba4b3b875083ad31b8c091d2d169cc2821fe9b23052cec0b37964450e"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_tahoe:   "728540264a2f7c9c18b0786f48c40bdc8bb988bb0095110f3585d6fb48ff4f5c"
    sha256 arm64_sequoia: "5075371b00db8bbb5fd4eeb67789e4d6b7e456687091135a07791954f22525c0"
    sha256 arm64_sonoma:  "0868f65049863fd28608a588672130de3d53ede4476acc129ffd9416bf2672cd"
    sha256 sonoma:        "48c6fcd569d4006c2f95af8d66ef2242a4b61ea52d20447b9e86482d1f44cb9a"
    sha256 arm64_linux:   "c2af9772ee3872f9f1efaea85e0f8c660308a1e1c0f857ad28d05d59275623d6"
    sha256 x86_64_linux:  "0ea14d14f99df5b315b1191fa62abc28bc236ce17ff5542915cd074e28169645"
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