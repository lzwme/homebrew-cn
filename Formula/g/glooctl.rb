class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo-edge/main/reference/cli/glooctl/"
  url "https://ghfast.top/https://github.com/solo-io/gloo/archive/refs/tags/v1.22.3.tar.gz"
  sha256 "69150674c01271cc1f9bd6b0970814f76e31d390d525a7662a5e983928ceb5d8"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b02ef50ef27e70bd06771cc4b4421bd80af2697489df5d8d83e7666193aa9c26"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3594730e1f3a296ac60a2a73523a6012c8ec4f2698b2a23cb961e9ed66e2c0d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a363bf94b8b4f9618ba6209f03c9dc8213f799c340f353a2afe07ca0ac4a583"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6adda73bdf542a6e88ed59e29e11439b2175d0bafa35c38ff4f59955430a89d"
    sha256 cellar: :any,                 x86_64_linux:  "cbcfc4e404d033f861ae32bc337af9e124936dd22b4bfea00baf611dab70ea4a"
  end

  deprecate! date: "2026-12-31", because: :deprecated_upstream
  disable! date: "2027-12-31", because: :deprecated_upstream

  depends_on "go" => :build

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