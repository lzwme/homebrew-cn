class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https:github.comcloudflarecloudflare-gotreemastercmdflarectl"
  url "https:github.comcloudflarecloudflare-goarchiverefstagsv0.100.0.tar.gz"
  sha256 "10f7d9c707f5df6ac4098c52985ef4399e4f9e156fb36d64a683a78c5baac44a"
  license "BSD-3-Clause"
  head "https:github.comcloudflarecloudflare-go.git", branch: "master"

  livecheck do
    url :stable
    # track v0.x releases
    regex(^v?(0(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b211f83ffad9a3e4bab1bab1ef2a7d777829ce948ff60e0ae8f0b02849aaa599"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "71feeeca0b304ca74740ba121a1dafb6ee138429c7d5e67112d345b67b8b85e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8698a8b3ea34513c9d6c2be98bcb42cc2d90ac389320ccfae5a5fc41e3dbc316"
    sha256 cellar: :any_skip_relocation, sonoma:         "92bfb2bd131b121adc723484739f3faf923708ad64b4cc4659daa07e92475078"
    sha256 cellar: :any_skip_relocation, ventura:        "dbc93abaf70a9a9641546739df27de7cfb27523a86e0fc7704ea074616f03234"
    sha256 cellar: :any_skip_relocation, monterey:       "b1ea8319ef2710b493a15b8ecd61f4758c997ad1dea0625e23e8f4a8018edf6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f95360d3373db454c9279b07435a4182287fa11538b2e3e435a6c53a1b2eb48e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdflarectl"
  end

  test do
    ENV["CF_API_TOKEN"] = "invalid"
    assert_match "Invalid request headers (6003)", shell_output("#{bin}flarectl u i", 1)
  end
end