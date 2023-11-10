class Libhdhomerun < Formula
  desc "C library for controlling SiliconDust HDHomeRun TV tuners"
  homepage "https://www.silicondust.com/support/linux/"
  url "https://download.silicondust.com/hdhomerun/libhdhomerun_20231109.tgz"
  sha256 "552a102e8aa2abcc416090dec2f6f80da59f97f91f57968e9e9d7b3dc005dbaf"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://download.silicondust.com/hdhomerun/libhdhomerun.tgz"
    regex(/libhdhomerun[._-]v?(\d+(?:\.\d+)*)\.t/i)
    strategy :header_match
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f2264222d9dcfd86785e1b29628ea231f09faa859d20d0686ab5aae4150320e2"
    sha256 cellar: :any,                 arm64_ventura:  "d5e27b09d11799f6da97373c809f30b3e1acbb27da035172f4ed4fbd31faf18d"
    sha256 cellar: :any,                 arm64_monterey: "1dfa25d40914aa4c8c61623c1ab7f7132352f98806d101f53cc355a33ee1bf0b"
    sha256 cellar: :any,                 sonoma:         "58bb0d9efa74814e8e6192ce79bbfb8e051c82a9b17d169cb510585ed3bd04e9"
    sha256 cellar: :any,                 ventura:        "65eacf311dc6a6cc9026c9f014f676afab021bb4f2757490512f53240fcbc093"
    sha256 cellar: :any,                 monterey:       "37b19d25fc0eb2c4e182f575616fc13646af2f2cd433f85e257728a8e35a070a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "664f2c0a133ec1bbc4ce59753777b07a497ff1472b4d2a4a9de6750f37e365ef"
  end

  def install
    suffix = if OS.mac?
      Hardware::CPU.arm? ? "_arm64" : "_x64"
    else
      ""
    end

    targets = ["hdhomerun_config#{suffix}", shared_library("libhdhomerun#{suffix}")]

    system "make", *targets
    bin.install "hdhomerun_config#{suffix}" => "hdhomerun_config"
    lib.install shared_library("libhdhomerun#{suffix}") => shared_library("libhdhomerun")
    include.install Dir["hdhomerun*.h"]
  end

  test do
    # Devices may be found or not found, with differing return codes
    discover = pipe_output("#{bin}/hdhomerun_config discover")
    assert_match(/no devices found|hdhomerun device|found at/, discover)
  end
end