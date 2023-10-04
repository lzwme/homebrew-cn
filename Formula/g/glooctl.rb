class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.15.8",
      revision: "f24a1b5ba407dc87bbfdd912ed226e1c7448828b"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0b888fc659fbb12d5013f6092759af80def6d2921d82d4ecb038d27a3a0692f0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "47dfef042687f07fe3a135a1dc559f82571aefe2aeb9681ecb027fda70b86d2f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0e75e6e05b34988c75409a27f4272df46aa9abd86330f39dbcd62bcfbc5e431"
    sha256 cellar: :any_skip_relocation, sonoma:         "c930d3ed3f57aa730330265d1e3bfa127ebe86f090469c261e73dccd7e10afec"
    sha256 cellar: :any_skip_relocation, ventura:        "74c2490e85b0986c361d07c119f6e567de843a6c0926b04229bec326dfc2eb9c"
    sha256 cellar: :any_skip_relocation, monterey:       "f1a3f32c16f556a44f54c001052e9d7901b7956beffbf725e33c4b47767974aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb6487a38b0b0dac6b9beb67f4de83b3bcf743845c5a93854eefb8f7659da0b9"
  end

  depends_on "go" => :build

  def install
    system "make", "glooctl", "VERSION=#{version}"
    bin.install "_output/glooctl"

    generate_completions_from_executable(bin/"glooctl", "completion", shells: [:bash, :zsh])
  end

  test do
    run_output = shell_output("#{bin}/glooctl 2>&1")
    assert_match "glooctl is the unified CLI for Gloo.", run_output

    version_output = shell_output("#{bin}/glooctl version 2>&1")
    assert_match "Client: {\"version\":\"#{version}\"}", version_output
    assert_match "Server: version undefined", version_output

    # Should error out as it needs access to a Kubernetes cluster to operate correctly
    status_output = shell_output("#{bin}/glooctl get proxy 2>&1", 1)
    assert_match "failed to create kube client", status_output
  end
end