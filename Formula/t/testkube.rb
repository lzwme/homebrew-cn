class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.72.tar.gz"
  sha256 "b6ddefc0a43dbb5f59c7fbd71a44ff7cefe9fb35069660102c539006e0de36ee"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4aee0c631949a846e98dba898ae7ccd4d2e33313882cdd647cf43bf2facec79f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4aee0c631949a846e98dba898ae7ccd4d2e33313882cdd647cf43bf2facec79f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4aee0c631949a846e98dba898ae7ccd4d2e33313882cdd647cf43bf2facec79f"
    sha256 cellar: :any_skip_relocation, sonoma:        "3dd93b3d4fb88fb5a622f9b6a0e8874c957112b684325ded4b1f2f75d7b65dfd"
    sha256 cellar: :any_skip_relocation, ventura:       "3dd93b3d4fb88fb5a622f9b6a0e8874c957112b684325ded4b1f2f75d7b65dfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9a39c4b401f6d8d4c14799309ed0097d2e7172886e6279099c01324064d72d8"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.builtBy=#{tap.user}
    ]

    system "go", "build", *std_go_args(output: bin"kubectl-testkube", ldflags:),
      "cmdkubectl-testkubemain.go"

    bin.install_symlink "kubectl-testkube" => "testkube"

    generate_completions_from_executable(bin"kubectl-testkube", "completion")
  end

  test do
    output = shell_output("#{bin}kubectl-testkube get tests 2>&1", 1)
    assert_match("no configuration has been provided", output)

    output = shell_output("#{bin}kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end