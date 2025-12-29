class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https://projectdiscovery.io"
  url "https://ghfast.top/https://github.com/projectdiscovery/cdncheck/archive/refs/tags/v1.2.16.tar.gz"
  sha256 "3c513d5c31c139c734eb04ea077e7eb722380cb56f57f5574194dfbc5d9db0d2"
  license "MIT"
  head "https://github.com/projectdiscovery/cdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2bbfcce892ffe8077368d7bdd7f46106dab5d483f3dfc2e08dd51014e0f4c293"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c5995bd4072a7f8ca6bf8df39d94bc1a38c5d5874be5737a40f15401451da38"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "221165a0b3fcaf7f7d0c31d5909961bef28e63c1f749303842c7aacdac82c518"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2704e6b0f09d10f7058b346796cfa0f22120a7d52bfe8673bd39120507895cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b2394360c285b2c3086eb382f7ad6fee1a478d9190a6b287c1ea04a8c6e7141"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef1387ccc65c9fd121521ae5b62592e5360d1c5e5433e0efdc2dacb177ec1ea6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cdncheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cdncheck -version 2>&1")

    assert_match "Found result: 1", shell_output("#{bin}/cdncheck -i 173.245.48.12/32 2>&1")
  end
end