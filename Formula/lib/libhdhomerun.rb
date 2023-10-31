class Libhdhomerun < Formula
  desc "C library for controlling SiliconDust HDHomeRun TV tuners"
  homepage "https://www.silicondust.com/support/linux/"
  url "https://download.silicondust.com/hdhomerun/libhdhomerun_20231020.tgz"
  sha256 "f0c2686ff0ab481fe7666290a1419c21f41934e641031539fd1c279175bc94ba"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://download.silicondust.com/hdhomerun/libhdhomerun.tgz"
    regex(/libhdhomerun[._-]v?(\d+(?:\.\d+)*)\.t/i)
    strategy :header_match
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "375ac2b152dac390363ca579cd398980bc37b16f35a4a53cbbabe4aca4cf29ed"
    sha256 cellar: :any,                 arm64_ventura:  "18ff29683fcc71597ae2e6ef9f462bb5cc8ab62c71fc0c83a57dd39d74546790"
    sha256 cellar: :any,                 arm64_monterey: "398d91bb808457ee94e4746f3b24efd89f8adb7a6b5c5db9aa66add2f07ae7de"
    sha256 cellar: :any,                 sonoma:         "cbeac3ede368fa73ae55c92a1ad3ab243a336b79f2ae7d3a5cf3938c01bb4e44"
    sha256 cellar: :any,                 ventura:        "5cbd80efe8a121347897006307cc602af8b03d56450d67490a07bb3f0a72726b"
    sha256 cellar: :any,                 monterey:       "fc710e80034c427339a2e6b92a88dd2dbe6687444ca92378de38cf52941c49d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8da7828362b82153004ed7c4129fbb94cea0da2cdbee5846f8f0ba39b8635b20"
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