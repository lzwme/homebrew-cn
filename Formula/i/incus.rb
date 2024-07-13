class Incus < Formula
  desc "CLI client for interacting with Incus"
  homepage "https:linuxcontainers.orgincus"
  url "https:linuxcontainers.orgdownloadsincusincus-6.3.tar.xz"
  sha256 "f16aca02c3193965ec3d3dec7566aaa2bc7e29110435a254e668eacb2e69c833"
  license "Apache-2.0"
  head "https:github.comlxcincus.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c4be8e02f727b7e0214d9ef55a3c03b5988a474a594e879ae3cca23e9427acb0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "42c44e248fd51ef14eca362d74a5fa8bb2ccdef53b9ae0e9e174b746e398264a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5af8e6c235e25a61c5218c8df5ce8c3e745dfc8d70d2e04752389c3e2d1eab39"
    sha256 cellar: :any_skip_relocation, sonoma:         "0189e620f2910f81733ddae8b85d9704bc65a8f00ce9279414f889dac3ad5e3d"
    sha256 cellar: :any_skip_relocation, ventura:        "20faa90d6959e65541813deec832702634866809471bbdc4c783ab4f06b87fb8"
    sha256 cellar: :any_skip_relocation, monterey:       "7acd80da115ebdd050967f90d2ac7890bbb503681cb732a200629e9531eba180"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "639e189e4145e0803ad60a4ad8550e96dc6cbe829d65b7a924761369b9cd3a8b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdincus"
  end

  test do
    output = JSON.parse(shell_output("#{bin}incus remote list --format json"))
    assert_equal "https:images.linuxcontainers.org", output["images"]["Addr"]

    assert_match version.to_s, shell_output("#{bin}incus --version")
  end
end