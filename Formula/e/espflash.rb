class Espflash < Formula
  desc "Serial flasher utility for Espressif SoCs and modules based on esptool.py"
  homepage "https:github.comesp-rsespflash"
  url "https:github.comesp-rsespflasharchiverefstagsv4.0.0.tar.gz"
  sha256 "6aff44a3b8e8d551066dbf4de6114b4629c273f9684a22757fa37b965195b67c"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b805654083340324b1522f1739f75d0d4c165975fd1c3f54a73c355f9f932df5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "468e4a9bd31a86112c84d0aaf01619e2de0d4f625a5c217d70abdb17190e627d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d868a5fe94538048ff58506df0021d2db7a9b0ab96fc9159101df5eb23322ea0"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba2e37b2ce4035b4e2a5c99e252087f5295df67ccf4462dc9681bbe8eeadca61"
    sha256 cellar: :any_skip_relocation, ventura:       "8f75b5772284b6821ab4bd72c250bb55f92e91cf3fcdb37ca714d080ed6a1f99"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9859d9bdf6e305acfc4600bc7cdff98547820d399a711ece58858374ff6b803a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27cac858fe0a3ac4eb629f4f4dea38d0f12bd9e8fd82ad6d0f62091cd80ab599"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_macos do
    depends_on "libuv" => :build
  end

  on_linux do
    depends_on "systemd" # for libudev
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "espflash")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}espflash --version")

    output = shell_output("#{bin}espflash flash espflashtestsresourcesesp32_hal_blinky --port COMX 2>&1", 1)
    assert_match "Error while connecting to device", output
  end
end