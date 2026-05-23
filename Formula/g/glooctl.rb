class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo-edge/main/reference/cli/glooctl/"
  url "https://ghfast.top/https://github.com/solo-io/gloo/archive/refs/tags/v1.21.6.tar.gz"
  sha256 "d95e0e57a83a94df5a34090c6adcd474ae2c99b6872748e09c72b7cfc6cb5b35"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d08d9f3deff17575a24758ea003bc0e88c89bb7f19fbc31fd0e6652c07f0e347"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00ad9f5fed0c2be752f3f12fae363f1c77ceab2e370fb8158c92a0bfa3edcfc8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "224bc5997f3828882f7b772612ae29f2eca005d04eb54a3a36e9b61895c4d740"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa405beeb152f496640f2f2610816065f1b04cd11bfbc4ee673315d0aad10c4f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "560d87fd1bb16f2d6ed8128a657e766f85aaf97bc45a09000b4a33579ee8e07a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4de3d14a4993be60565f304b950e3ac244c9eccc024b5d971dfc8519c31a425"
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