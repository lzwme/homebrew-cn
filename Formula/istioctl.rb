class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://ghproxy.com/https://github.com/istio/istio/archive/refs/tags/1.18.1.tar.gz"
  sha256 "3ca4370fa94df4704ed4350e998c177abe83aff24eabbcf9d9bb6619961bcace"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4e34b182a1a90d6ad7888269f48f8502c252f8d27677b0a86c9b0b6d27788789"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "846bad65b3b29765e103a77bb2aaae08895636ce95b341777fff1138143854e2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "53a12129dbca1f4fa1d4d356bd9a2d3bfe03c2b41d85d7b2e240c8d14b6c8782"
    sha256 cellar: :any_skip_relocation, ventura:        "832a070e14fb16abf87a8de156cb1b9c0a67487dd0ba09a7ada15a9da3f3976d"
    sha256 cellar: :any_skip_relocation, monterey:       "b142617426fb1445309c4f3a80f59580dd8367f88c8182f42adad99178c99ff0"
    sha256 cellar: :any_skip_relocation, big_sur:        "850a47325eec07a9eac338e3fe8c5c7aba7235d2e6ea7e9c223448fb10a3461e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e371c2d80705456a16e80f9d0400e03cbdac9f98cd83a4c982805dcd4304f04b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X istio.io/pkg/version.buildVersion=#{version}
      -X istio.io/pkg/version.buildStatus=#{tap.user}
      -X istio.io/pkg/version.buildTag=#{version}
      -X istio.io/pkg/version.buildHub=docker.io/istio
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./istioctl/cmd/istioctl"

    generate_completions_from_executable(bin/"istioctl", "completion")
    system bin/"istioctl", "collateral", "--man"
    man1.install Dir["*.1"]
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/istioctl version --remote=false").strip
  end
end