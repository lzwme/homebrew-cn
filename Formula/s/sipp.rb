class Sipp < Formula
  desc "Traffic generator for the SIP protocol"
  homepage "https://sipp.sourceforge.net/"
  url "https://github.com/SIPp/sipp.git",
      tag:      "v3.7.8",
      revision: "741ee230bfda890c8605253b32b449dfef3dd421"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7b7c8f2c83843426ae8a0ee55bf001e267b07b159b241619bfae550f75cb74ff"
    sha256 cellar: :any, arm64_tahoe:       "d86175424861489a045269e986f88646395cd3e48b8a3a2beb578026a5c66734"
    sha256 cellar: :any, arm64_sequoia:     "75d5968b8e0954c9c09f8c81f419a491cc04df6f01fd2adf447f214c66ec8d8e"
    sha256 cellar: :any, arm64_linux:       "8dbca031af559688827135846853c5d8849fa2bf7afb326f0dc50a0a096ba547"
    sha256 cellar: :any, x86_64_linux:      "997b814f1b05538c8bfb9ab978fe8610feff992fc03a7891b2f932de9bedb38b"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@4"
  depends_on "pugixml"

  uses_from_macos "libpcap"
  uses_from_macos "ncurses"

  deny_network_access!

  def install
    args = %w[
      -DUSE_PCAP=1
      -DUSE_SSL=1
      -DUSE_SYSTEM_PUGIXML=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "SIPp v#{version}", shell_output("#{bin}/sipp -v", 99)
  end
end