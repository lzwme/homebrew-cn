class Libcec < Formula
  desc "Control devices with TV remote control and HDMI cabling"
  homepage "https://libcec.pulse-eight.com/"
  url "https://ghfast.top/https://github.com/Pulse-Eight/libcec/archive/refs/tags/libcec-8.1.4.tar.gz"
  sha256 "61302836cc21c610b6fe0c751e4f130296828f191ee2650f80f73a376fe8c90d"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2efa2dcfc05e646bb612fe329db9c9625b5fd78e7f7f7914282134a208018f2d"
    sha256 cellar: :any, arm64_sequoia: "2db5fd4983232bb47a1ebc196a9b9abb7c6a417dfc33118855286a47dc693437"
    sha256 cellar: :any, arm64_sonoma:  "d51d2cb226db339b65fc8f9fbdbdbc25d72134c21e1feafc3260fab36f7c14ee"
    sha256 cellar: :any, sonoma:        "b202b2c600b67c2d92488c6665e6553978075f60be8eb9ddfa08d0fde5976912"
    sha256 cellar: :any, arm64_linux:   "cdd6b93f58ec672e7ead9909c822aa0b1e99226b0be582f66d36a5ef9dbea230"
    sha256 cellar: :any, x86_64_linux:  "1a5905a48a662790043b8b1a90eb9ad2e650650d76e812768fabbca3356ed3c5"
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