class Rio < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https:raphamorim.iorio"
  url "https:github.comraphamorimrioarchiverefstagsv0.1.2.tar.gz"
  sha256 "20e20df7c2bee3eafb8a112a7c8ce9977a154edce46e31237ce93445f2db07f0"
  license "MIT"
  head "https:github.comraphamorimrio.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "28b6ae90d034bf6d03a0635786a943924b8a4d82dd37f0e886e8909438a9d793"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5abf2093c5a5a0acc5b83088737bbcf2664fb296d1b8b2c798443e7ca719cc91"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5dd4d7edbdd358194c6ac63216799adac869f80b3c3bf3d2a3f8b2670e5960d4"
    sha256 cellar: :any_skip_relocation, sonoma:         "ab7a7f0a88af803cc402bab23ba61c4a8c31fc8065b7f05f59eba4a0f6dbebc9"
    sha256 cellar: :any_skip_relocation, ventura:        "7a771ecebb18f9992d1f03b6aa4f6c86b5ff4942168eac0d2c3ff305c303fb64"
    sha256 cellar: :any_skip_relocation, monterey:       "f1d059b76fd1db0f073d3a9eabcb1950219bff11884e76bb3d89e982ae3152ac"
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