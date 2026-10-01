class Sipp < Formula
  desc "Traffic generator for the SIP protocol"
  homepage "https://sipp.sourceforge.net/"
  url "https://github.com/SIPp/sipp.git",
      tag:      "v3.7.9",
      revision: "16aff5f67fd776d0bf79a895930c53b72e98ccfc"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "3e7413ea703fa2da55b773812de9d33412e7f22f53324e372fbe98703bb2507e"
    sha256 cellar: :any, arm64_tahoe:       "811524259216601de1a45775c38732df1f66d3231d3a716ed6a68eb54d192e21"
    sha256 cellar: :any, arm64_sequoia:     "2af422175974e7d2102d8bed59e04e65274bb46a8ccaf0f95b8c4dbb60de1c8c"
    sha256 cellar: :any, arm64_linux:       "e1db0c13fca5dae6d01e36273a21a26f884ed5e1f0b895a4880b9874b07b9fcd"
    sha256 cellar: :any, x86_64_linux:      "a4505c411a22cc7bcddf58c4345e2bb902ac6f696c36f69f97a9fd776a306ffb"
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