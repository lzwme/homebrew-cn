class ProbeRsTools < Formula
  desc "Collection of on chip debugging tools to communicate with microchips"
  homepage "https:probe.rs"
  url "https:github.comprobe-rsprobe-rsarchiverefstagsv0.28.0.tar.gz"
  sha256 "34587f8ee19d53da37d6f9b4290ea97a787883773f2182605b049a0ede3d4dfb"
  license "Apache-2.0"
  head "https:github.comprobe-rsprobe-rs.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03e1b1281897b805e973b3e750fdfc0a72005820116c1a651d27c0e992cf0368"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00cc6a3a8c0b5c1578527deeeb0c5cf3de7bba59b49ac6160d98241ff50e5bc4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "98037082bc41d37a505c88adbfdd80f4964d896a6b3c03de79624007ab312205"
    sha256 cellar: :any_skip_relocation, sonoma:        "a83e0ba8fca0a65fef56ce8cc39f54706244ccb9aab6ba01de717df0377157a0"
    sha256 cellar: :any_skip_relocation, ventura:       "86ca3a0f81e7fbb40a1bab87f68f28ad292155b8d62e1c3fdab52438063c3c2d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67e057ea57e598669a8abda9b6e645289194729184f0616d534360add0fa5522"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1afdb729a45fe0b55a10de41c2480952c14eee42b14e5e2e6bcfdcd8777273f4"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "systemd" # for libudev
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "probe-rs-tools")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}probe-rs --version")

    output = shell_output("#{bin}probe-rs chip list")
    assert_match "nRF52833_xxAA", output # micro:bit v2
    assert_match "STM32F3 Series", output
  end
end