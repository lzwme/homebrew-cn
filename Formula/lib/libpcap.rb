class Libpcap < Formula
  desc "Portable library for network traffic capture"
  homepage "https://www.tcpdump.org/"
  url "https://www.tcpdump.org/release/libpcap-1.10.7.tar.gz"
  sha256 "0b394ac90dbc0a9838ff97468e05c9c9a3e873dec2514cd58db65d859d296e31"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/the-tcpdump-group/libpcap.git", branch: "master"

  livecheck do
    url "https://www.tcpdump.org/release/"
    regex(/href=.*?libpcap[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "fd3f8727be7b45984842238e001afaaee450d2de82bfacc6d951080004d0cd5b"
    sha256 cellar: :any, arm64_sequoia: "05e57c37d24e3cee254ae605df54a6c9d5b84a3a6174e8323134fb0fcfe6a73b"
    sha256 cellar: :any, arm64_sonoma:  "b4054a068360b8e7bc0508ef39808aa7af9e5befd00ed160852b33c69017a3b3"
    sha256 cellar: :any, arm64_linux:   "84b15f243f3d95766d793e7ee2e99aa6cebf4ca4a2cfe8e05593e5edd00df01c"
    sha256 cellar: :any, x86_64_linux:  "2468a6570ba38b8ae345b3cbfa1f2f5538f4c97ef9c0413760bee6d89115c7e1"
  end

  keg_only :provided_by_macos

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    # Exclude unrecognized options
    std_args = std_configure_args.reject { |s| s["--disable-debug"] || s["--disable-dependency-tracking"] }
    system "./configure", "--enable-ipv6", "--disable-universal", *std_args
    system "make", "install"
  end

  test do
    assert_match "lpcap", shell_output("#{bin}/pcap-config --libs")
  end
end