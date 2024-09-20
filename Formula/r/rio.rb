class Rio < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https:raphamorim.iorio"
  url "https:github.comraphamorimrioarchiverefstagsv0.1.15.tar.gz"
  sha256 "2e06774a23f9f3def6c4abb3d29ada88ee2f96e88235929251b4e7dd7cd5dcf1"
  license "MIT"
  head "https:github.comraphamorimrio.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c3637894deb1722dd12b4fb0a4d44e3b266723f1ad751650559bd0b2cb10655"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e2a03eb2132ed99ad556cfab40248af3e9a33cd049f543fd346b7a10c486330"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f0db665816e317c34b7e68071d60a86e9a24a73c334168353588b0067931d9d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "f572f5c1ab7dcf54aa273be7e864ff9bc7e11bed2709626bfa2af8815ef16753"
    sha256 cellar: :any_skip_relocation, ventura:       "7ec90f47118b7aeabfe63f8602cec8e2d030a580822a179b03edbd298c157868"
  end

  depends_on "rust" => :build
  # Rio does work for Linux although it requires a specification of which
  # window manager will be used (x11 or wayland) otherwise will not work.
  depends_on :macos

  def install
    system "cargo", "install", *std_cargo_args(path: "frontendsrioterm")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}rio --version")
    return if Hardware::CPU.intel? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    # This test does pass locally for x86 but it fails for containers
    # which is the case of x86 in the CI

    system bin"rio", "-e", "touch", testpath"testfile"
    assert_predicate testpath"testfile", :exist?
  end
end