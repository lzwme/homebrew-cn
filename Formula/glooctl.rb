class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.14.2",
      revision: "63d99efc9a253ea7a28d0e66e1b2a333fe46ba62"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b6668fe13bc057c8509265a277a806d3e78912268534150177a0566b93a4d7d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb810cd1917a7812d2f5eb3b10318612a0b228fa2424f5cf6710d23c522fee69"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "60698b8f3b8480f9f7a297abe1dfdf9495c9b2583d6de6cc6ef535866e39b040"
    sha256 cellar: :any_skip_relocation, ventura:        "11acc2a5a369e1452f157b9327bd57e0ce69f480d04e9e489c31e47922c44291"
    sha256 cellar: :any_skip_relocation, monterey:       "a82fd8c6ecdb9f988b3d7c17a2475bbdf902ee64288f6e37fed199dc059e5e37"
    sha256 cellar: :any_skip_relocation, big_sur:        "d092bd724b538cf538ca69a3b61006a34c8ea2566da9046a38cb4c359859f3e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e64be27c7fdfe369836b35c1d68551d1c8ac6f73a696e0ad96f8ed2608b6d71c"
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