class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo-edge/main/reference/cli/glooctl/"
  url "https://ghfast.top/https://github.com/solo-io/gloo/archive/refs/tags/v1.20.11.tar.gz"
  sha256 "d536f4b707826efbcdcfa5696947a3709833a8a830d31c3c95be369ee0b69645"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9e7727046028f43ab4c9c7f11deff75dade0b7801ad932438c3ec031548bedd5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f47a0d49fcb193e5428d4099810717a7652f3a69f49947786ca479e3a45611e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59435620a364517e419b94a4664ba4044b631ce85efbdbff3ae401822feb6d48"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c1fac564a64a99ccd6a5a240082199f27b4560a8e35d2edced93b942327dcde"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "90c3e9e8d6a40d155763db6c7c41be94b8af9a1e6e2f1b3cb500d527b7bb2e85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b514907fde3334540f3987049bc222d013d934b994458a37064ad8a8a3071c6f"
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