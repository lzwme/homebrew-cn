class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo-edge/main/reference/cli/glooctl/"
  url "https://ghfast.top/https://github.com/solo-io/gloo/archive/refs/tags/v1.22.5.tar.gz"
  sha256 "0ceb9781700594c7edfbf29bebc73e3d2d8f047f2bebb3ad3205f9a8dc010f25"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "adac856bb46fee3db490710f7a5e7809fa524b4a4615894413115490febd095c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cc9818c7cf81c7f00cf6847598aa456da305c552f92126e75004bb8164f827f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1a6176c58bd484f07c19f81f44a6da036f2b4cf6af378a26b81b5de0953bb45e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c20c2d8418e9dfd243a640273684a6da0e0b729376d8693813cfed77add20e13"
    sha256 cellar: :any,                 x86_64_linux:      "540a3c8fb15c21c6b4ec5860388737df4f705496593003db8b5339287fe87fd7"
  end

  deprecate! date: "2026-12-31", because: :deprecated_upstream
  disable! date: "2027-12-31", because: :deprecated_upstream

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "--X github.com/solo-io/gloo/pkg/version.Version=#{version}"
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