class Libcec < Formula
  desc "Control devices with TV remote control and HDMI cabling"
  homepage "https://libcec.pulse-eight.com/"
  url "https://ghfast.top/https://github.com/Pulse-Eight/libcec/archive/refs/tags/libcec-8.1.1.tar.gz"
  sha256 "0247a2e577cefceaa1932d9a2aec2b423e0ce9c77f90c2b8a99197fdd1a0b81d"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3d39f28b55ce9f33cd9e9b4ada7940a4d603e41bcdb9c81572438bc090776112"
    sha256 cellar: :any, arm64_sequoia: "1cd10d82ceb262fed2f8f9dcc0e2ed3bdab51ecd2366132535cb9d0658c0f471"
    sha256 cellar: :any, arm64_sonoma:  "11dd24b75a41f9a49ab70d7aa8c300afc9f9d60e48c5f4cf06b37f71747d53c9"
    sha256 cellar: :any, sonoma:        "e735147cc771dcf1e33bcaa4bef52ca654f1ca4571e12d443286e9c4c96af1fc"
    sha256 cellar: :any, arm64_linux:   "a92696d525d8a62027a6995c10307c4e1f6e36c36b6a833bcab28767dd5ab072"
    sha256 cellar: :any, x86_64_linux:  "340264b622c380f1ed00afcf2b8acc70ae8e0d1d8f6f02ccc8f5e05970de0fb2"
  end

  depends_on "cmake" => :build

  uses_from_macos "ncurses"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "libCEC version: #{version}", shell_output("#{bin}/cec-client --list-devices")
  end
end