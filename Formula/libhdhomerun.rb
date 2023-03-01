class Libhdhomerun < Formula
  desc "C library for controlling SiliconDust HDHomeRun TV tuners"
  homepage "https://www.silicondust.com/support/linux/"
  url "https://download.silicondust.com/hdhomerun/libhdhomerun_20221205.tgz"
  sha256 "29eb09ca528abf45d3feed512a847b98cdfff89609f133855a8dc6cecb8b62f9"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://download.silicondust.com/hdhomerun/libhdhomerun.tgz"
    regex(/libhdhomerun[._-]v?(\d+(?:\.\d+)*)\.t/i)
    strategy :header_match
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4e7e782aa7f4fe6add0e3d22d94cedf74cd801d197088f77b476fa5066c10043"
    sha256 cellar: :any,                 arm64_monterey: "99c3171961a55c9416d3855ddaeede187af6ef58d739108c1e759855f4566e84"
    sha256 cellar: :any,                 arm64_big_sur:  "6f969d30b4013ea5d115826138199a0cc2379a91664f30ff0ba030521025920c"
    sha256 cellar: :any,                 ventura:        "7bac3def509cb691660a6ceba7eac0121f02e1fc3f58764e41f33f7f42331494"
    sha256 cellar: :any,                 monterey:       "445471f463ed4776a69eddc08f5c5620375cab97e73f9a64b454aac1d2f857ea"
    sha256 cellar: :any,                 big_sur:        "ce0c09daeaf97ef46b3694309165b89660fa8533af79ec529849be49df285d77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "053b10a9359b0930021478ffd4ec5545de4ce9c39d4cdbfa207b846c96e50fcb"
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