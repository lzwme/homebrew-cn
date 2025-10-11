class Nickle < Formula
  desc "Desk calculator language"
  homepage "https://www.nickle.org/"
  url "https://nickle.org/release/nickle-2.106.tar.xz"
  sha256 "692ff0b392c0c69dadd4544b8a456a4d938b92f4c8f03f7200446dc09fba5d6d"
  license "MIT"

  livecheck do
    url "https://nickle.org/release/"
    regex(/href=.*?nickle[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "363c0c8081d99b828d43df3c52239379e1b1f5ccd7e0fbf4ff28eb94b6b025eb"
    sha256 arm64_sequoia: "10a3be1081052d87a604b155ea1beb4e0f904299c9dbccf0ce059bf643632f81"
    sha256 arm64_sonoma:  "b14238055c3db8d1433c93e64ca1c7d9b37945d057264dc2465fba85b44a0862"
    sha256 sonoma:        "ec985b7e0c65d085b1ea87b51ac6c71daae2b0f2cf4d4e14991fb95f3338e578"
    sha256 arm64_linux:   "d4f59efbaf588aae29b5ab81d37ac51435f2903f560b55314cfc7461e9419294"
    sha256 x86_64_linux:  "89f5491bbb81f1a13eecb06529ffc69a6c7a3ffe1e8bd43b4b3f0ce8fb884c37"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "gmp"

  uses_from_macos "bc" => :build
  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "libedit"

  def install
    # Fix to ERROR: None of values ['gnu23'] are supported by the C compiler
    inreplace "meson.build", "c_std=gnu23", "c_std=gnu2x"

    system "meson", "setup", "build", "-Dlibedit=true", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    assert_equal "4", shell_output("#{bin}/nickle -e '2+2'").chomp
  end
end