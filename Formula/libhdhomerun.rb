class Libhdhomerun < Formula
  desc "C library for controlling SiliconDust HDHomeRun TV tuners"
  homepage "https://www.silicondust.com/support/linux/"
  url "https://download.silicondust.com/hdhomerun/libhdhomerun_20230713.tgz"
  sha256 "aa8f1c23e6d38f0d684426cdc1cbfced953a2a9dec3fbe645ab11c15a8c0b4d6"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://download.silicondust.com/hdhomerun/libhdhomerun.tgz"
    regex(/libhdhomerun[._-]v?(\d+(?:\.\d+)*)\.t/i)
    strategy :header_match
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b9391d2974b45998c8fa381b8b9cdc8b21a16ad5ddae2d701582fad14ed128b5"
    sha256 cellar: :any,                 arm64_monterey: "60be89b6c9d246d3b9f67e7a7f9c399b1d48516f3df6a1cb2313683f53b42d1d"
    sha256 cellar: :any,                 arm64_big_sur:  "4a3da2c1ecbaad1dcce4854cfb9a0e53c5cdde3569d816f13bf7b98c6f75a9a8"
    sha256 cellar: :any,                 ventura:        "880d42451a39b4c44364f2b329ba972b2ad2ba937d19975380b3b77531421d4d"
    sha256 cellar: :any,                 monterey:       "ed0225f3af4282679962aa5bd32b3b87f2d08df106d30ae389a24f459d322747"
    sha256 cellar: :any,                 big_sur:        "bf62036b134a19d7a54895984d580ee7400fa9a9f89d16569b0078cb608e55cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b7501bc14213510abe4257a6337ec94e45827cbc7b553b405842d33acb2d917"
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