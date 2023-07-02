class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.14.10",
      revision: "ff07b61c5ef1a72dcf6dc7dee41b823791cff725"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "440910750f56e26ff165061a91c8457d8a06c54e5eb6a520fe971027e28e9020"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70047640e3398625bf02577ce3de41bf7e7ef6cdd95a26f899a3cf322c833e9b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b9a4810e5065347ca36acc1098a6261dccc4692352e5447a0388600595a54297"
    sha256 cellar: :any_skip_relocation, ventura:        "fc45135743106255c556f7ceee08ed2df7b83d7115e193ae0b344140f11a66bc"
    sha256 cellar: :any_skip_relocation, monterey:       "0abb31f030b30d08809a988a48c27ea45609261fc322639b9a47223b74980b87"
    sha256 cellar: :any_skip_relocation, big_sur:        "096085a25d39ba11842a4ceca849f66c973f80b06a8c33419e1dc07d1d978ee0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4df2eeb4c46aa731758c032990c5b806ac107534f2e87dc8e5ec59f231f716f6"
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