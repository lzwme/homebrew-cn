class Avrdude < Formula
  desc "Atmel AVR MCU programmer"
  homepage "https://www.nongnu.org/avrdude/"
  url "https://ghproxy.com/https://github.com/avrdudes/avrdude/archive/refs/tags/v7.1.tar.gz"
  sha256 "016a5c95746fadc169cfb3009f6aa306ccdea2ff279fdb6fddcbe7526d84e5eb"
  license "GPL-2.0-or-later"
  head "https://github.com/avrdudes/avrdude.git", branch: "main"

  bottle do
    sha256 arm64_ventura:  "153e82b4dcaf4819b8eb08485392fb66346c89340ddc682ad567ac0e20b1073a"
    sha256 arm64_monterey: "8bcf7ba0c42c763fb26e035d528ad1c9aee7996bb13936b20d232977e239f2af"
    sha256 arm64_big_sur:  "29841e83dcfffe270236c1d0ae38b3e12b38a57b7f538e773b1d4c0765afc6ef"
    sha256 ventura:        "70682c2e5ea06dde187953d8c39ffbbde8106f337fc2953626d8e32fb44e903b"
    sha256 monterey:       "afcb908d0862f38423b88a215551fe899cb5e9589a55ea4a1a96fdf9c9e390e7"
    sha256 big_sur:        "cf690b8c39eae957712aed6f3e12d2fc87674b2664441a4a1b31036bcf9377f0"
    sha256 x86_64_linux:   "3a2bf4b7c4f5c47866db54defc83d6145c80c406c2ee4100652fab04f079559f"
  end

  depends_on "cmake" => :build
  depends_on "hidapi"
  depends_on "libftdi"
  depends_on "libusb"
  depends_on "libusb-compat"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  on_macos do
    depends_on "libelf" => :build
  end

  on_linux do
    depends_on "elfutils"
    depends_on "readline"
  end

  def install
    args = std_cmake_args + ["-DCMAKE_INSTALL_SYSCONFDIR=#{etc}"]
    shared_args = ["-DBUILD_SHARED_LIBS=ON", "-DCMAKE_INSTALL_RPATH=#{rpath}"]
    shared_args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-undefined,dynamic_lookup" if OS.mac?

    system "cmake", "-S", ".", "-B", "build/shared", *args, *shared_args
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    system "cmake", "-S", ".", "-B", "build/static", *args
    system "cmake", "--build", "build/static"
    lib.install "build/static/src/libavrdude.a"
  end

  test do
    output = shell_output("#{bin}/avrdude -c jtag2 -p x16a4 2>&1", 1).strip
    refute_match "avrdude was compiled without usb support", output
    assert_match "avrdude done.  Thank you.", output
  end
end