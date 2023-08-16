class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.14.14",
      revision: "cdfdb14afe9cd79fbf5adf73e07c09c48fd181b4"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5782b4b508350cb8229ca3229d5586310b4f0712c3ac75788c75c443c8b78c38"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69634f6800ffc42fcda1651dc05b7985d1021366c27535cb1688331f337e4684"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "84bfe85267b7af335fb069e5fa4d177e70a70b2da26fc5ace46fee2ea5ca4c80"
    sha256 cellar: :any_skip_relocation, ventura:        "03a18db97973e64baf89dd97a128053d12b1045f03d441afdc64ee6b1801a546"
    sha256 cellar: :any_skip_relocation, monterey:       "7952411fe1fc91e2f5fd4f1f92ff7449d4820304087736a0d607f838bb628b6c"
    sha256 cellar: :any_skip_relocation, big_sur:        "1102ef1e214c0f26b9be2b201273a4c19202e2bac0322598ed4dd3f96a35d3a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bccc4dfbc5b6e89c405e7e647596449618ec56bf1a2968483ff087fc4e16a20d"
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