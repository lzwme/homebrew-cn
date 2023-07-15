class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.14.12",
      revision: "3870e91520fa5229bdeb1e7efd89e4ae9ff3c8ea"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "37cc21e752afc505c3ce00bb47a0b525d0abf1ce0790aeb1dc0ca083d6ce870f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "436c9616ca907e4b58817b794d3825ea07a433cc3dba0c0f1e5a83896a1e1ef8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0ec007a53ec52980e09bba024dd0f038b5fa329e29c36c039f2b6d69f84397f9"
    sha256 cellar: :any_skip_relocation, ventura:        "5b441aa33999222dcf1a00b2fe332a137d488caae5a13420f8f4432ccca70c92"
    sha256 cellar: :any_skip_relocation, monterey:       "4130f855288c6fb3afab3f0202140b4fec77a0fd457aa7506c47b18983463ed6"
    sha256 cellar: :any_skip_relocation, big_sur:        "e9fbd03691b352f2f765514a523056ea7980fba14b715c1d30fbd889b48cc924"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc5f1a2fce507f7210f61f9fa5d5349ad52c96c99daf0c607fed4e373229987e"
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