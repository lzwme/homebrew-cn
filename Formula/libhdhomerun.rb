class Libhdhomerun < Formula
  desc "C library for controlling SiliconDust HDHomeRun TV tuners"
  homepage "https://www.silicondust.com/support/linux/"
  url "https://download.silicondust.com/hdhomerun/libhdhomerun_20230503.tgz"
  sha256 "aa8f1c23e6d38f0d684426cdc1cbfced953a2a9dec3fbe645ab11c15a8c0b4d6"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://download.silicondust.com/hdhomerun/libhdhomerun.tgz"
    regex(/libhdhomerun[._-]v?(\d+(?:\.\d+)*)\.t/i)
    strategy :header_match
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0db30251d06263e7e32ca64e2e4bc0ae24e517a65b44c4b4898dc0299d033383"
    sha256 cellar: :any,                 arm64_monterey: "a8a760f9504f702579bcde621b675f44e7f8a2466c7585719faee6ccbb530ba2"
    sha256 cellar: :any,                 arm64_big_sur:  "00881d6f2cc4e26c09b58a24aff6bf56e8f754d5931a7f63ba048b8d0e1bfdb2"
    sha256 cellar: :any,                 ventura:        "7e7ae0ad41e2493c8769f11aa6016f6aebe875388707073b9794add1a54d82d0"
    sha256 cellar: :any,                 monterey:       "0f0b9caf52874ac78f683f0a84653658f11ab75ffaf3e5a94dfa5e8e06c79fdd"
    sha256 cellar: :any,                 big_sur:        "5bb90ce4289b6905d1cf72c2ddf4081f604eff2fdbdb1084961e315d48f35121"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15930fb3fc70815154676237392e20d6c31ae7ab398e4715b5940b56947adeba"
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