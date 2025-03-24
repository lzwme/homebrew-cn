class Ubertooth < Formula
  desc "Host tools for Project Ubertooth"
  homepage "https:greatscottgadgets.comubertoothone"
  url "https:github.comgreatscottgadgetsubertoothreleasesdownload2020-12-R1ubertooth-2020-12-R1.tar.xz"
  version "2020-12-R1"
  sha256 "93a4ce7af8eddcc299d65aff8dd3a0455293022f7fea4738b286353f833bf986"
  license "GPL-2.0-or-later"
  head "https:github.comgreatscottgadgetsubertooth.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "fa7215f06163e3333e33b92dd89476ced1eaa8f7ca3c2f5e790494832cb73cac"
    sha256 cellar: :any,                 arm64_sonoma:  "640cbd39fd3290bec4eecaef753ba84135b5c000b08d7c0fe455971df354390e"
    sha256 cellar: :any,                 arm64_ventura: "dbf1e2cf18fba265c0119a87fd659ee8331d2bd54dcdd3bf07eabda6de17cb41"
    sha256 cellar: :any,                 sonoma:        "50f74c97eecde210eeb23a86df867e4824034605544048ae9e39f0e9bfd2d532"
    sha256 cellar: :any,                 ventura:       "c6acf9ec2c33e2fdf289a33f52e1ca4e9c2e10c81225a06d6c41ffd9cd730fba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "452dcee2cfe766cd5b230dd29fa5c8e2691c15f0d9850e64afe45cdda1cf43d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2cd546fd818a705d9da6c089bf001471ca9d46b03fd6241a2528f0da22c71b9c"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libbtbb"
  depends_on "libusb"

  def install
    args = ["-DENABLE_PYTHON=OFF"]
    # Tell CMake to install udev rules in HOMEBREW_PREFIXetc on Linux because it defaults to etc.
    args << "-DUDEV_RULES_PATH=#{etc}udevrules.d" unless OS.mac?

    system "cmake", "-S", "host", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # Most ubertooth utilities require an ubertooth device present.
    system bin"ubertooth-rx", "-i", File::NULL
  end
end