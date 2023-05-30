class Kyverno < Formula
  desc "Kubernetes Native Policy Management"
  homepage "https://kyverno.io/"
  url "https://github.com/kyverno/kyverno.git",
      tag:      "v1.9.5",
      revision: "f4efee1daefacb4d391f48dfcb8f025478e4e332"
  license "Apache-2.0"
  head "https://github.com/kyverno/kyverno.git", branch: "main"

  # This regex is intended to match Kyverno version tags (e.g., `v1.2.3`) and
  # omit unrelated tags (e.g., `helm-chart-v2.0.3`).
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "719012cf34156b6ee5a25def18d2bcd121efc06824f1f55595ce85046f891639"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc168ec7ca6a1ece66b8461d448cbc61dd92e379e23f93f5a5b3cff1516e690e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "440cc0e4d8997e73c1dec71a5728c6a7054b76938a89127b08cd4e6d90f63e7c"
    sha256 cellar: :any_skip_relocation, ventura:        "3a4edf2752e9a94d765afe5556a9b58c9150f366fff67c282abcc9e207080b49"
    sha256 cellar: :any_skip_relocation, monterey:       "cbd6d7a9ea62ece6cee39da3f1f5ea72ef4e915da6391d434d200e603954b202"
    sha256 cellar: :any_skip_relocation, big_sur:        "d86b393a6b6bd4f814c578ced56c51cfcde4fc69239d347311fb5d46faa0a0f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "362ebbd4872a39082a5b135939c25531239d31546a099c8d2525941427f4e6d4"
  end

  depends_on "go" => :build

  def install
    project = "github.com/kyverno/kyverno"
    ldflags = %W[
      -s -w
      -X #{project}/pkg/version.BuildVersion=#{version}
      -X #{project}/pkg/version.BuildHash=#{Utils.git_head}
      -X #{project}/pkg/version.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/cli/kubectl-kyverno"

    generate_completions_from_executable(bin/"kyverno", "completion")
  end

  test do
    assert_match "Test Summary: 0 tests passed and 0 tests failed", shell_output("#{bin}/kyverno test .")

    assert_match version.to_s, "#{bin}/kyverno version"
  end
end