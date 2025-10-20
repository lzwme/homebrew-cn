class FleetCli < Formula
  desc "Manage large fleets of Kubernetes clusters"
  homepage "https://github.com/rancher/fleet"
  url "https://ghfast.top/https://github.com/rancher/fleet/archive/refs/tags/v0.13.4.tar.gz"
  sha256 "129e7ea9f5a994e0f7a291195220f34f47f47170278880b4e97c97dadbec57c4"
  license "Apache-2.0"
  head "https://github.com/rancher/fleet.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ebc131c8167a06b5d7c2401f03a6d939811a8bbd49938a0ce98567845efd2bbf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08d79cb94fe96c0bb79f34e70a0f5b7c70204c5b86de46c4c1758b6a6f48917b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e085bff97e4039a9143c1e18784ee29614dd3bdc75421dfe2e65775800c59103"
    sha256 cellar: :any_skip_relocation, sonoma:        "84b29a27cd222042cd2b52f17940e2878353712e1e4c6602b2cab764bd016af9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2fb09a91c66a4c760e6f99d4d8995e085c98ff1d6a5934c9254f96a6dfb6b9f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02c7f2a78bf6126f679cd27a3d3a4a2144522a66bfb44cad90f594d45341e30e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/rancher/fleet/pkg/version.Version=#{version}
      -X github.com/rancher/fleet/pkg/version.GitCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(output: bin/"fleet", ldflags:), "./cmd/fleetcli"

    generate_completions_from_executable(bin/"fleet", "completion")
  end

  test do
    system "git", "clone", "https://github.com/rancher/fleet-examples"
    assert_match "kind: Deployment", shell_output("#{bin}/fleet test fleet-examples/simple 2>&1")

    assert_match version.to_s, shell_output("#{bin}/fleet --version")
  end
end