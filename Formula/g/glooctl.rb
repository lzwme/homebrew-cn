class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo-edge/main/reference/cli/glooctl/"
  url "https://ghfast.top/https://github.com/solo-io/gloo/archive/refs/tags/v1.20.10.tar.gz"
  sha256 "959391524f1c50d2219c67b737c0e93203bfaaedf7b5959ad4bf695cb8cf9415"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e024560e10bbcd3f20d4b0e09a7e7837218064535ef430694b1b8ceabab9d2c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f73286094c7ab23b42c892d6632e7b0a38a11314dfff0dbc295b60b51204e88"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22abd9400653e99357516ab78c6f992e4f401623bd43868dca0a5bdb119f8ce3"
    sha256 cellar: :any_skip_relocation, sonoma:        "27f12111948be8a92dab547cf95c28e2217d876b477825fad6a9fbdb9148fcba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d2033a40f08bcfd07b464e853a53928ea6e16b8199ca2e7beb0ab16596cee23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0dc4847e521dda226cad808056cb2f378be3c14497bc8ea3155d7069b6f4c79f"
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