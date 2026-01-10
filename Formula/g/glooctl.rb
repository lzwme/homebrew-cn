class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo-edge/main/reference/cli/glooctl/"
  url "https://ghfast.top/https://github.com/solo-io/gloo/archive/refs/tags/v1.20.8.tar.gz"
  sha256 "43fb00cc9206b1799d3d068cd0895c3b371c6baf7ad60f530046423371a80eaf"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9d12dccac53fae079f984181be0a0f541e7a535950c27d3d9348705a69b4b507"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b07f80a16db55c13042a70b56ef4f6ee6016bb93e4844c129c45e3f92f0de3c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cae0fd948d1511f21b976ca0ceacb3be5604767260034885dcd5b30d579ca631"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f85c9a0c8a585b986fec71ca600d363f9fdb5fa47dab406fb3442bb88c76e77"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12734db4319356722d34db1980bf3a645da02d9e272e3d7d47e29efe3c49374c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b30130c7c8b5222cdb94c4b14f822ff6ecdbe9bb98974af8df861c2a201d5092"
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