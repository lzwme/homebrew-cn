class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.14.0",
      revision: "4f26aac35465404a2e411f377420cd53d3797a9b"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b91d5bdee783485c9d513fd3ba1e86cb998d3925abde3d952babd027951f07c8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e16c3b9a3c17315353fd7ec217e41fa9ca7eb074a00c0deee476d8b855ab572"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3cc4236fd5ef6122155ef67fb0d3635b05237092f1f1227c9936f93c59aa189c"
    sha256 cellar: :any_skip_relocation, ventura:        "18b54933eb82c5ad1695b911ce471d967fdd606b452a87006fdf57dd90af4a6e"
    sha256 cellar: :any_skip_relocation, monterey:       "5da433312f7c69c70e54b452959c94f7deb120e39a27bb2ccf139e0d32d92ffc"
    sha256 cellar: :any_skip_relocation, big_sur:        "5d49bfa35c8c7fb9f29058d79f740bc0c1e0d207acd1cfacebe4f21d98230c8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7dbd59914c370bf249d7de33eed903cbdb3c73ca9781fa5074a26552e7b894b"
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