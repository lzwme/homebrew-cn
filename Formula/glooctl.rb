class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.14.4",
      revision: "acf5fc97f7ddcdf83f7e8378007cd507ab86a855"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "17a74566f4b571c7b79c35b77a82bce088a5c7cac440199c27725803ee4c4944"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98e829ad648c8580f40dfd7ea504759d587dfccd9cd51575577dc4ff2db4f23c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cd609b794427af63f9aacd9526fc66126e96bb13e17037e848217ff98874a379"
    sha256 cellar: :any_skip_relocation, ventura:        "1eda955f3be6a698b5a945623ab2a2f38723876e3ee920c3b3b0b715a4687ff5"
    sha256 cellar: :any_skip_relocation, monterey:       "1c1dc1f17c87b02f96b2ff91ff4cfb273094d17a27e9e4d39a5b4c24d370d85c"
    sha256 cellar: :any_skip_relocation, big_sur:        "7e7b8ac3c922f0deb4bebbac1e3ea6766a60cb4aec6108b786fd6c132b2e49d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71ac8a5be8a67485aa660de7975a6db3d1e108df6ee071604036e56ef41a0344"
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