class Kyverno < Formula
  desc "Kubernetes Native Policy Management"
  homepage "https://kyverno.io/"
  url "https://github.com/kyverno/kyverno.git",
      tag:      "v1.10.1",
      revision: "8ae004000344987ec4e5cff82c3c5651abbfa8fc"
  license "Apache-2.0"
  head "https://github.com/kyverno/kyverno.git", branch: "main"

  # This regex is intended to match Kyverno version tags (e.g., `v1.2.3`) and
  # omit unrelated tags (e.g., `helm-chart-v2.0.3`).
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a6fc360296c52a9c7cff790fd9907f9097d10bc0f15a6a9572e1f16d5ba16a4b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86c609358917192d67b3a06cbcd65d061dabe77f030e6edad390ad506631e6a6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ddb1113cd3a25cac31abb00ab869f0dbb269a4fda84ddd7226e4d4b3f63b636b"
    sha256 cellar: :any_skip_relocation, ventura:        "a433e41b662251ed697aef28a4edf5dcbea993dc560e1b5e68ed2f973b170fe8"
    sha256 cellar: :any_skip_relocation, monterey:       "f5a1e305602bb244b35fdf2d6c15fe04d9ef272e2a572605ed965f97c4987ee2"
    sha256 cellar: :any_skip_relocation, big_sur:        "8ea897d844be51fdad272be0d41294ba3ccbae8f09b39928941cfb1b631a439b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e078739ff3a8a361427c8ff2e4de66ddead311e2e846c38eaf5bfb57bc6a83f"
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