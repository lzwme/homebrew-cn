class ProbeRsTools < Formula
  desc "Collection of on chip debugging tools to communicate with microchips"
  homepage "https:probe.rs"
  url "https:github.comprobe-rsprobe-rsarchiverefstagsv0.25.0.tar.gz"
  sha256 "693d76eb1ee697d420781e28cfbb4e527c6176eca327a4c92e26daf7e52c153f"
  license "Apache-2.0"
  head "https:github.comprobe-rsprobe-rs.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd7cf5c0a3d4f6c648fc35359cd8fe44e078cf166bfec00273ad4bbe4af76fde"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b8935645d2d27d33430a0278ec8623f98b459abae7a2c5e4b9cf71859aa1480"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d48195dc2d4080c0b439bd356be8a037702597f835aed448d955e8090aaf2a67"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ff873dd619df88e20aea02d2782a4a3ee893e9eaa2a0a99911d333867ecae3d"
    sha256 cellar: :any_skip_relocation, ventura:       "f84ef1e8b6af4e5e24efe093af77d11d05f000c6e872ab0fb3fb9b70030a806b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b153b5f7f3a16476fdcdacd073d8bf4a5491e96992bed94cb0c4fc9acf35ca9"
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