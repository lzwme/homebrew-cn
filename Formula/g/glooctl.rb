class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https:docs.solo.iogloolatest"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https:github.comsolo-iogloo.git",
      tag:      "v1.17.2",
      revision: "6d1b50c3632c59e3b8cad662555f60098e2345d5"
  license "Apache-2.0"
  head "https:github.comsolo-iogloo.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9ee06a61ecbda6cebd33f534d4660f884f27e0f1393af4019ee6d80691c4cf91"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "78e5ca9c907f3dda0fcc5cf6cc5cf31a11da0796e1e3d306bec9f0998d884391"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b08176e4cea9f3c7e4f0e9552a183a939adc76cc12d0fc75f2158decbc6b6984"
    sha256 cellar: :any_skip_relocation, sonoma:         "052c6e551826eb8651bd90973d3716b7306e6196265d16cd21995c729ad86666"
    sha256 cellar: :any_skip_relocation, ventura:        "06589957fa2f0209aa991f5600a86e9c020126145dd56cf81a0ab7f166c2e86d"
    sha256 cellar: :any_skip_relocation, monterey:       "c80bb17dabe9a3879e8a53a9523993b081879260eafb15e14086e0d5a41a5521"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1172a8db90605b5fc416e33ee2d1941c57e7fd24696db5c3ca261ad552f52bbe"
  end

  depends_on "go" => :build

  def install
    system "make", "glooctl", "VERSION=#{version}"
    bin.install "_outputglooctl"

    generate_completions_from_executable(bin"glooctl", "completion", shells: [:bash, :zsh])
  end

  test do
    run_output = shell_output("#{bin}glooctl 2>&1")
    assert_match "glooctl is the unified CLI for Gloo.", run_output

    version_output = shell_output("#{bin}glooctl version 2>&1")
    assert_match "\"client\": {\n    \"version\": \"#{version}\"\n  }\n}", version_output
    assert_match "Server: version undefined", version_output

    # Should error out as it needs access to a Kubernetes cluster to operate correctly
    status_output = shell_output("#{bin}glooctl get proxy 2>&1", 1)
    assert_match "failed to create kube client", status_output
  end
end