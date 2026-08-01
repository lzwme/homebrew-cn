class Libcec < Formula
  desc "Control devices with TV remote control and HDMI cabling"
  homepage "https://libcec.pulse-eight.com/"
  url "https://ghfast.top/https://github.com/Pulse-Eight/libcec/archive/refs/tags/libcec-8.1.3.tar.gz"
  sha256 "c7b208433418991a9ae7af1d43ffebf99ddc27ee7119a2794f19dcc02e4568b1"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a6751299dc4b08b33db6e50802ff4ff5fe9b5dfa5e34e735388b1a81dbeff654"
    sha256 cellar: :any, arm64_sequoia: "3a32f750e57fa3ab562f15e57bd328463299f6e93bf5c5392a4b75f428be694a"
    sha256 cellar: :any, arm64_sonoma:  "316571cc94e7c0f8a505a1cbf94f7a44bd5db7342e02394683d82235b7206a7c"
    sha256 cellar: :any, sonoma:        "ef2a36b3155b74a633c8d1d1848b43d7f2b468e05b1e935b62ad46a99d69400a"
    sha256 cellar: :any, arm64_linux:   "d89165395186f1c1071a7de250d4463478f5ed3faefbc0c529c30ff8aa26d178"
    sha256 cellar: :any, x86_64_linux:  "c1eff02c5bd6b824f745c3ffd1572467c3e6af81d2e27195d089c724fa7b8b8f"
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