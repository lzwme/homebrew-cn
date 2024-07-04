class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.0.3.tar.gz"
  sha256 "c4181dc7baa43a8d0d3614134f081f6145ae8916d317be9b371a17dc2ef38e22"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7d22b72b216a7358b0505701d3c4e938bfacd00df01fba05153576891a7707a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e1ac1041dc7d5b833fe165d0c6fbc543aef20a559328e5b25e531938545c6da3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "45bc5aede25932da6800841ec35d79098a5dfd81716f5bb796c913b8a5ad2a13"
    sha256 cellar: :any_skip_relocation, sonoma:         "06bddac1e54e130fef3b71e7c137c2fed4758e17ed3f1acd59ac947b2aa0a1ec"
    sha256 cellar: :any_skip_relocation, ventura:        "4366903327aa7e790448d0548af190ee1d541ffa5695b68fb0dd9f806ce7a31a"
    sha256 cellar: :any_skip_relocation, monterey:       "b9392e6e89fff6395e2649b7f9f27319803becad556d306cdcb7a5926090d926"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5012d293f890dcd1e033a565ceeacd6e30dd6646ad917d2b6b906ea0c807a5ea"
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