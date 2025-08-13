class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo-edge/main/reference/cli/glooctl/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.19.5",
      revision: "7822e7b07829320037bb6b4bffa804330868e572"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c43ae061e4f5d048f14390c5208f1bf87c0aee6469f4d33a12566f0bb02a04b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "01b16a9a6d024e29c92d750e1facab51deb466f08696b8c4ec0272cfa593d1e9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9657dcc4c4955916f643a5aa6ce6d685a699ae6a4dfe10ba07c787808e9bbc3e"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff95563627357986d00925037830b07078255084fc5021bddf282857273bd65d"
    sha256 cellar: :any_skip_relocation, ventura:       "2d315c7e9a2886d2994c46cbc5b3eead60ec3dd667bcc72dde57ee9223bb80e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8b954ba0b8488857c21b161b20d3ddffce37ea50b7b0aa4665de2da7c465d1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d3d4dccd7c1eed4f0015412bb35a9155e01c357d1e1d73c13db30859f5e9567"
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
    assert_match "\"client\": {\n    \"version\": \"#{version}\"\n  }\n}", version_output
    assert_match "Server: version undefined", version_output

    # Should error out as it needs access to a Kubernetes cluster to operate correctly
    status_output = shell_output("#{bin}/glooctl get proxy 2>&1", 1)
    assert_match "failed to create kube client", status_output
  end
end