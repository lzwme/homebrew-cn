class ProbeRsTools < Formula
  desc "Collection of on chip debugging tools to communicate with microchips"
  homepage "https:probe.rs"
  url "https:github.comprobe-rsprobe-rsarchiverefstagsv0.25.0.tar.gz"
  sha256 "2125485e416674b1b884619dc98cb9fd21e598e7b52cc15dec7b125614b8196a"
  license "Apache-2.0"
  head "https:github.comprobe-rsprobe-rs.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e63f6d0b668a88a7449c66b29c69d220d5d7c2c7816d6a8d8880cb3126694a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3458a0332529a9ef090e33f83a858b6fa7d00d89a85be6b41e198ebc84b0d197"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3ec1433139b3ec527d923e836cf47674b8f2e5a7e558af4edef920876213d5c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "1347bf571c113783bdd44f98cc276aa4ceca0dfeecd09dd8727ef81eddb44248"
    sha256 cellar: :any_skip_relocation, ventura:       "63d426fdbe29691c93d2bde5b28656a97f34083ca6091a7f9a41abbf52925042"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37989366f509304d671025fd691f4413a4fe9409735311036b2550bbdab7a52b"
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