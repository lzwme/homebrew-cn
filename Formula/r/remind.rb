class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-05.05.00.tar.gz"
  sha256 "cc57fe8399cdc443344b9d1413bc31d47732156438bdd1d3d82d1a833ffacbed"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sequoia: "72b7c6cf293cdba0da842d4ad264d4363f616ae2982d96387310db673da36f7a"
    sha256 arm64_sonoma:  "01fe56de8d203553799c28934b32d965e7f30ac52a57f9b8645d6110f845a1eb"
    sha256 arm64_ventura: "450df40a16ad1cfbae8cf47aee8781df50722c2da077ec2b08847e1f1a8d28ce"
    sha256 sonoma:        "a905e1ccd76c9c3df06293d47f7e4f98af67e87af61b50dc7babf9b93a10a30c"
    sha256 ventura:       "01ae12dcfa6f03ca6563e0b29e7c5e74f696dfeaaf8c8d3e725d8e75fedc441c"
    sha256 arm64_linux:   "6fc3aa4edb8d34310cf4cf9a1c7df861f96176567c904b075fb4996aee0b8cf2"
    sha256 x86_64_linux:  "17d0fad35adc3a150fb206b0cfd1379284eb1e2034d16f01145f8f283fd3a38a"
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