class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.0.8.tar.gz"
  sha256 "78607ef57154bdbfc8d8e01cc65bb7be9987b6bf429ce13f2bf9ea0fa18992fd"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fd57e0a7a8d09c2e93764a2dc3c038c165b5520a15f9db7a732dae46a1ff556d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "63b7778df5d921269d883804bd9ae0654ef5fea683611eadacc58c9617c25b76"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "191354c183b742a079b130ea16e2f1e2a22c5d360a4a84e168dee69dc443a906"
    sha256 cellar: :any_skip_relocation, sonoma:         "94a581ed3edcb4f2f02225641b64dc56d6efa3f135de1ce2553c7fea158f276c"
    sha256 cellar: :any_skip_relocation, ventura:        "47c8374b531735058e31a4d13d75d837807b306bc4117b87fa86d204a47e8077"
    sha256 cellar: :any_skip_relocation, monterey:       "a25c308cebce67574b52788e947658e21a12bb3e729cafb6f5fe8b3fc75c570f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01748ce4ecc2cc0b52adda3d4b787619c8f33acb09cd0e4968ef2d459319dda2"
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