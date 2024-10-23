class Bittwist < Formula
  desc "Libcap-based Ethernet packet generator"
  homepage "https://bittwist.sourceforge.io"
  url "https://downloads.sourceforge.net/project/bittwist/macOS/Bit-Twist%204.4/bittwist-macos-4.4.tar.gz"
  sha256 "b8392dfdb0fa2bd7105c323d3447efaa69197312d5e6a9c493c9f724abdbf007"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "951cf4ae0578ae798b3c32fafba144f613959a6e13c4065c961a824e74dd5e72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e866f7a847488c12311dfcebf65b1f79ceee7f223419392a8c644007f5c27b0f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2d679a1c1010639d42d116e6ad64d17fd31125f83aeb4495381e6ba55cc07317"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f690feb3437e9cc804cd15ddfbc48973aa018402f3862cf41810b23e437253f"
    sha256 cellar: :any_skip_relocation, ventura:       "8f302fc221d5e1a55fd9bdfa623b1113db96f1ebbff4aba0e13235edab389509"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff12a02bc96d904355373ca433793547ba6da631d9b8b13e3e6bdfada834cbbd"
  end

  uses_from_macos "libpcap"

  def install
    system "make"
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system bin/"bittwist", "-help"
    system bin/"bittwiste", "-help"
  end
end