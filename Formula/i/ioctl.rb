class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https://docs.iotex.io/"
  url "https://ghfast.top/https://github.com/iotexproject/iotex-core/archive/refs/tags/v2.3.3.tar.gz"
  sha256 "e6502d310408d1f4ae8f215abb87b9d11a514a72f5c532175a065edb7f35dc78"
  license "Apache-2.0"
  head "https://github.com/iotexproject/iotex-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7fcc7d0943fb950ccbae5a9968018d2da86e8df26e5e23e6d15b90e0327b23b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b22f27928fb55c3e8014dc285873b6bd9848ad0e276e75116f62040c1dc574c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fbeb1198e6a0e6d7203943ffe0bbf252201fb4f4bb52277187c02ffcfa268abc"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c54bf515f40fa9b00c9a67c7630c16d7b83a864bdff86963fecc1623cb3925a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06cf829f8a2f17a965fd4ae45b6de2bafda1e4792bacec585eb6f2fb13787eb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63c242f28dbf7d03f103c5eaeafe28b96c7984180311ed1593c1e988746d3024"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1"
    ldflags = %W[
      -s -w
      -X github.com/iotexproject/iotex-core/v2/pkg/version.PackageVersion=#{version}
      -X github.com/iotexproject/iotex-core/v2/pkg/version.PackageCommitID=#{tap.user}
      -X github.com/iotexproject/iotex-core/v2/pkg/version.GitStatus=clean
      -X github.com/iotexproject/iotex-core/v2/pkg/version.GoVersion=#{Formula["go"].version}
      -X github.com/iotexproject/iotex-core/v2/pkg/version.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "nosilkworm"), "./tools/ioctl"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ioctl version")

    output = shell_output("#{bin}/ioctl config set endpoint api.iotex.one:443")
    assert_match "Endpoint is set to api.iotex.one:443", output
  end
end