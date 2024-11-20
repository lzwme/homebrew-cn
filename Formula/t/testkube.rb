class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.67.tar.gz"
  sha256 "000b1feae638cdcf982d8149353cb9a3662c061f5814735782f113ea200c55f7"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "662fe263e37caa1a5d666101baa0213ab7e1f399681fa927b0e535e8b6b49ccc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "662fe263e37caa1a5d666101baa0213ab7e1f399681fa927b0e535e8b6b49ccc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "662fe263e37caa1a5d666101baa0213ab7e1f399681fa927b0e535e8b6b49ccc"
    sha256 cellar: :any_skip_relocation, sonoma:        "e221e6eda3f9878e25c92517926c83e6d9644cdec8515c6f6b34ede39f1f4993"
    sha256 cellar: :any_skip_relocation, ventura:       "e221e6eda3f9878e25c92517926c83e6d9644cdec8515c6f6b34ede39f1f4993"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52b1a0de55061bb6233a1c1330d097bedc6a57d9919dcd4dbcf0ea9921a7b7dd"
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