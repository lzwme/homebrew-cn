class Rio < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https:raphamorim.iorio"
  url "https:github.comraphamorimrioarchiverefstagsv0.2.17.tar.gz"
  sha256 "3290d6c3bf4663432938f17b42310de9cf0327753a75c1f54215ec8f7b66a4eb"
  license "MIT"
  head "https:github.comraphamorimrio.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ded2b1f7e80cb603248d91dca75a0dac62b360c2ff2226342a119ca2ba193f88"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d91e45ebbed91ee1961b6e5d225bb63186a43ef7e9e4a0582fbf7872f886b70"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "71306f1aef973b018a50754f6473f92d68ad1abe9edea72195cf0769b157cb53"
    sha256 cellar: :any_skip_relocation, sonoma:        "e3dfb003c16f41287f1a3be11914edf6b13b8b1e70fd0ea65413508251a08600"
    sha256 cellar: :any_skip_relocation, ventura:       "9af55f6296f895cc0b15db662f5c88aacbb716eaabad12a1dfbf9f2e69070022"
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