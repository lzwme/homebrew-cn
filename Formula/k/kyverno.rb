class Kyverno < Formula
  desc "Kubernetes Native Policy Management"
  homepage "https://kyverno.io/"
  url "https://ghfast.top/https://github.com/kyverno/kyverno/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "e8438e3db721dc2eb793b01e4571442907313567b5894daa6d64070d44ab3ebc"
  license "Apache-2.0"
  head "https://github.com/kyverno/kyverno.git", branch: "main"

  # This regex is intended to match Kyverno version tags (e.g., `v1.2.3`) and
  # omit unrelated tags (e.g., `helm-chart-v2.0.3`).
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b09fee3f02524bef3ad47d3f5f2b7e937f4341e1afc8044a28a04846127e23ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b695ff62496235f42ed8d6c05591406b5033cde5bc09bf1d4e8a5ea0e24bb30"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3575201243f2db4d2b6a4d435cea4a35dec0583ee2f5171bca2eccb08187d6d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "4353262b834d006a8314f4a99eda4b4e3b15d3f990601d26340dfac56ffa61e1"
    sha256 cellar: :any_skip_relocation, ventura:       "76d86af7b322f16d7458a2a5fa68ac087e0464e64546472d5ec3bb7687434ed8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "17a4da086d3bb91362ada9d426ab35cea71b9754643b29cc88bd4f50a4eccc6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b1f4750049367098eca3dd555ac5c7d4a2bbeebe0bd6216e7913371c500cbd2"
  end

  depends_on "go" => :build

  def install
    project = "github.com/kyverno/kyverno"
    ldflags = %W[
      -s -w
      -X #{project}/pkg/version.BuildVersion=#{version}
      -X #{project}/pkg/version.BuildHash=
      -X #{project}/pkg/version.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli/kubectl-kyverno"

    generate_completions_from_executable(bin/"kyverno", "completion")
  end

  test do
    assert_match "No test yamls available", shell_output("#{bin}/kyverno test .")

    assert_match version.to_s, shell_output("#{bin}/kyverno version")
  end
end