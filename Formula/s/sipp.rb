class Sipp < Formula
  desc "Traffic generator for the SIP protocol"
  homepage "https://sipp.sourceforge.net/"
  url "https://github.com/SIPp/sipp.git",
      tag:      "v3.7.6",
      revision: "5c4e8dca7221714aa50dd91956f0b62804978550"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b3418caeedfb4e765e40349c432029d3b26ba7d7e610249f3e880a67e716aa71"
    sha256 cellar: :any,                 arm64_sequoia: "03f5608002b8a090d50434a3f65b27922350ac2ba14d23ff542557ddd54f241d"
    sha256 cellar: :any,                 arm64_sonoma:  "a51384b2a8ffae961da812fd37ef9006065df137ad35f04487c0476ca698a589"
    sha256 cellar: :any,                 sonoma:        "fb89b5835c73ac9ed9b04f345012aec70d7485c1d49e021e2113e1f7545d7978"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4738168bce385cac7e69b3f9d0bdbeab656fe57d956b1facb0e3622ae3690c96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2db1c2ea156f338c6a10de36ac1195bf59708718d30692336895c7a07084556"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  uses_from_macos "libpcap"
  uses_from_macos "ncurses"

  def install
    args = %w[
      -DUSE_PCAP=1
      -DUSE_SSL=1
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "SIPp v#{version}", shell_output("#{bin}/sipp -v", 99)
  end
end