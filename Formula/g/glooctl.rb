class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo-edge/main/reference/cli/glooctl/"
  url "https://ghfast.top/https://github.com/solo-io/gloo/archive/refs/tags/v1.21.9.tar.gz"
  sha256 "a623eb34e4c6c6b5c1b5140bf22d252634ea031afaf143efd008269f8bc8483e"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubReleases` strategy.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d42cfc2be9dc415786a4e6e1f84c83e910050cc76d499c224bb3d2a4cc59ffd5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "750796546036aee5f3734e83b3e91089890d156585be8a0b71aaf1d1672061ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d36bdfae05712e566fd392abbae36c8571cae7ea554f0e0f75900dbb57deacc"
    sha256 cellar: :any_skip_relocation, sonoma:        "d304a2c499c02922b012846a4e5230e3b01643b62959934615ef3d9a72eca851"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e09fff27980d49a8127aea372015f3adfacc8c4b843a8a3aeb55a7930c9f6df"
    sha256 cellar: :any,                 x86_64_linux:  "6db7690e335124c2f480216d3e9a595922a7f0a74cec6a641d51b4b035974b3d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/solo-io/gloo/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./projects/gloo/cli/cmd"

    generate_completions_from_executable(bin/"glooctl", "completion", shells: [:bash, :zsh])
  end

  test do
    output = shell_output("#{bin}/glooctl 2>&1")
    assert_match "glooctl is the unified CLI for Gloo.", output

    output = shell_output("#{bin}/glooctl version -o table 2>&1")
    assert_match "Client version: #{version}", output
    assert_match "Server: version undefined", output

    # Should error out as it needs access to a Kubernetes cluster to operate correctly
    output = shell_output("#{bin}/glooctl get proxy 2>&1", 1)
    assert_match "failed to create kube client", output
  end
end