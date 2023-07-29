class Kyverno < Formula
  desc "Kubernetes Native Policy Management"
  homepage "https://kyverno.io/"
  url "https://github.com/kyverno/kyverno.git",
      tag:      "v1.10.2",
      revision: "25f091412be6e335690d97e15013124f1846337e"
  license "Apache-2.0"
  head "https://github.com/kyverno/kyverno.git", branch: "main"

  # This regex is intended to match Kyverno version tags (e.g., `v1.2.3`) and
  # omit unrelated tags (e.g., `helm-chart-v2.0.3`).
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d5660860905f02a4b8d34d94c80d8ce1317afb0a0dc52ef79f24c03f5c48542"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b8497ebbfbaaec56200d9a69175da15b8376ab30778fb0c01037d963e569173"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bcbe65d3401f6d56353cd991be781aafb9519d557ddaa2e60ad926face22402c"
    sha256 cellar: :any_skip_relocation, ventura:        "6bd5e2eb44eb2fd163fc1af81b61e23d659be100390fc89769d2510c7d56b36b"
    sha256 cellar: :any_skip_relocation, monterey:       "832192f1900ca070128198f362de7ff70cd8120fc3c0c4b4a460f10c2bff9f48"
    sha256 cellar: :any_skip_relocation, big_sur:        "6f3f5caefa7e690aeac37d13825b815a443e9744b7ec4fb9518ae2ec3506e497"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac603d1008393b46e61990563f4e2509a43cfd4b1442237eec714671612f06d3"
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