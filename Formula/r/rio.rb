class Rio < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https:raphamorim.iorio"
  url "https:github.comraphamorimrioarchiverefstagsv0.2.15.tar.gz"
  sha256 "cd5f32e546b8b49554d6a341421a445e431ff3e347648aea2c4120d9c81dd82d"
  license "MIT"
  head "https:github.comraphamorimrio.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50cc084a1fe6c67abcccea58ef8e3aac6bc66b2bf4165fc5b52cb524be3bee08"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d81a77ccde76fa7886a977a7d79ab4a62c090d39fd799af951f97f7ce7d4bc18"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e8a74e845f9036eb3d2749d9ed11e3629118faa4fb8070241e79a79e2719266b"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ffc892ffdcb26124dcaeafe8ecc3aa7efc0a6968b4e7bd649bd65eb897f0af9"
    sha256 cellar: :any_skip_relocation, ventura:       "de8dada41114df4b63ee68fa69c592ca37e5cd4093beaccd447b87ee3ca70d9d"
  end

  depends_on "rust" => :build
  # Rio does work for Linux although it requires a specification of which
  # window manager will be used (x11 or wayland) otherwise will not work.
  depends_on :macos

  conflicts_with "rasterio", because: "both install `rio` binaries"
  conflicts_with cask: "rio", because: "both install `rio` binaries"

  def install
    system "cargo", "install", *std_cargo_args(path: "frontendsrioterm")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}rio --version")
    return if Hardware::CPU.intel? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    # This test does pass locally for x86 but it fails for containers
    # which is the case of x86 in the CI

    system bin"rio", "-e", "touch", testpath"testfile"
    assert_path_exists testpath"testfile"
  end
end