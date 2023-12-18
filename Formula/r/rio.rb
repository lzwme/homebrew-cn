class Rio < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https:raphamorim.iorio"
  url "https:github.comraphamorimrioarchiverefstagsv0.0.32.tar.gz"
  sha256 "36d6a0a00022b9b21d08857e1d2d9b6b95990d4e5484bfa8c43353d3787a66fa"
  license "MIT"
  head "https:github.comraphamorimrio.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ad3785df47a16baba0aa1938f14322218d3e41c3e83df360120b740ad93e678a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b59653ac292af28a262e3bfaeb5adb462d5a7150ab6efce5be70fd8bb9a2f216"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64343b0eb48198815d0136b46e5d7107898b706522b6464964ad91b755e24959"
    sha256 cellar: :any_skip_relocation, sonoma:         "68a7e221c91e6df03ebc8b791cd27d4f0cfd6c19595f514ac3a6863ef0abe7b0"
    sha256 cellar: :any_skip_relocation, ventura:        "b75968085164709d128977752b0dfbe07f7cc34e45a21b51ad5517fd698267c6"
    sha256 cellar: :any_skip_relocation, monterey:       "03e80917caddcd8d6f14df09d8a3d2a1ba755ad546d34cee08484be7506b5ce2"
  end

  depends_on "rust" => :build
  # Rio does work for Linux although it requires a specification of which
  # window manager will be used (x11 or wayland) otherwise will not work.
  depends_on :macos

  def install
    system "cargo", "install", *std_cargo_args(path: "frontendscross-winit")
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