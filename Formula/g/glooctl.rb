class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo-edge/main/reference/cli/glooctl/"
  url "https://ghfast.top/https://github.com/solo-io/gloo/archive/refs/tags/v1.22.2.tar.gz"
  sha256 "581e6e3755a97ea7ac4a932e471f64b2977a0607881429dedcb86e1acfa973c3"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b8587a0c3b9f3fa308ce67bb1aa2b90de7c322ad016e700bedf42c345ed0acb6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "339b3f01340ec83efbac7875927b0aed391d5d2d4a900daa0301b09a32d0bf76"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "397b9d91ad787b4cd50322735247a721f1dd1e92e13b2e8d164b83f021dfb42e"
    sha256 cellar: :any_skip_relocation, sonoma:        "dce672ac7eab7938a4f919a4da65bcf21ddba2d6a6d310c5af60d23bb956758f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f150fd988576184e19beb5133669c2a703ea80ec8047b52365abbb97577b7483"
    sha256 cellar: :any,                 x86_64_linux:  "c924ab409cfd786e0114363d537498ec434e35d1a8d1c389b5e62dd2c44a0880"
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