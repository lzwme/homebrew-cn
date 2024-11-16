class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.63.tar.gz"
  sha256 "c8110103efba83ef91461fbc4d5be69686ccf9b71279dfc9fd1035b1215f6483"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c0394f5481deccb224b913dc7086cc5c395cf3b2238a02dee15124f08bf7fb4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c0394f5481deccb224b913dc7086cc5c395cf3b2238a02dee15124f08bf7fb4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6c0394f5481deccb224b913dc7086cc5c395cf3b2238a02dee15124f08bf7fb4"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b4a99b173021a1b12d3a2b0edc19bc666c66f116d63fbee488245ed942389a1"
    sha256 cellar: :any_skip_relocation, ventura:       "9b4a99b173021a1b12d3a2b0edc19bc666c66f116d63fbee488245ed942389a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32dc3ed0a8368cc1d54a3c2304e7fdc2ab5a9c86b9ed3e22240fcefe26ff42e0"
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