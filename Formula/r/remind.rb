class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-06.00.01.tar.gz"
  sha256 "0705b6f700d6cd7b0f59af106495f7dd726ea14b641d9d8408f532fb28d2f007"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sequoia: "1ed2f2ca8a5b9d89774a8d78fa1c945706641302ba5df3fefcabb435dbb9304f"
    sha256 arm64_sonoma:  "284b7f3b9ac52755750fdaf3695e4f5abfec923a88d448f6e4ffc63849e390f4"
    sha256 arm64_ventura: "c1b0a299ccccbbc3087786331911c9c5083cc60e344ce988cbbcf406726e1be9"
    sha256 sonoma:        "69e433382670efa0b5e86d2e616d5f409998e832eaac9d66aa3ad7917bdac99b"
    sha256 ventura:       "274971f7f508e0ae046d17dbb742b5288528379e80cac90a00b6de09a76539b1"
    sha256 arm64_linux:   "a736b1d9ab98946ffc36529f13735d6df39034394fb887be88c9b6ba3b6323c3"
    sha256 x86_64_linux:  "00a4f0ef7dd110797056e2d3f802d87de21cacbf13f7c532e1f77e9a5a9d20d5"
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