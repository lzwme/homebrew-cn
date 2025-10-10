class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-06.01.05.tar.gz"
  sha256 "2faded4b8bb60d32fd8bb600bc86b293bdaaa14724b3791fe1fa6a8d801c7fca"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_tahoe:   "da4ca3cd6cab1e366111d583421cfebe9a59a4970d44d1d56fb1bd1cecc57670"
    sha256 arm64_sequoia: "f6c4d2d16534c9b65efe378d90a7355c7ce910b01b78bd4bcdd440860309452f"
    sha256 arm64_sonoma:  "6834d1fdafe99c68b1c10c1dacd0fef33f535b3b2caa3e839fb7a0c97991fbaa"
    sha256 sonoma:        "9b6a5ddec03d3fdbf0257f1a31f361103f7deffba02e0f42977e3841fceac190"
    sha256 arm64_linux:   "7cd3ccb958e1b65d73d2cab77804a18838d5a985be7e1dae864e9be6ddd2830e"
    sha256 x86_64_linux:  "9430bf884538265350ec3939134645fc9989d16888b62cb30c44badba454d9a1"
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