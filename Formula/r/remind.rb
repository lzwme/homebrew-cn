class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-06.01.07.tar.gz"
  sha256 "a553a35cd330c3b6c83eace499ea25da9ebbff6e4137951c1660fbd74a54321a"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_tahoe:   "41bc3750e25af8c53bf0f91cf17406f7114c40f7391f3d39514855b6f2dd6a63"
    sha256 arm64_sequoia: "36b6681c16eb392ca6be25f2cb0afb410e3ec4fb18daf09ab925999e41aea609"
    sha256 arm64_sonoma:  "bf89285aa825e6f9324755c0332567a0d8cc786cff17070804e8c921656818e4"
    sha256 sonoma:        "461e45126fc227202ed22b2789b7b3907eed4ba64d60b7a05e994e87c7b23a7b"
    sha256 arm64_linux:   "23453c2f4b3ba1e47f8b0ed0ef99bbbeb6fa04e77e830f592ba0b171a2faa1c5"
    sha256 x86_64_linux:  "0d90b7b32fa221bc2bae9f30dc22ddd731a81e7961e857a36e232f7d26e60e96"
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