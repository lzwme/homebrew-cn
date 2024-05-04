class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv1.17.23.tar.gz"
  sha256 "5972c2c4b5821e8ae074af54618d3b4f34d136e27390079489dbd94cf51834d8"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "56fee2c46313607e1f820c99a7cfcdd2acb3144f70bf590a29ef63af6d8fa916"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4cf97920356f41f15792b5e18fea574f9a14b162fdc3a1a21dac3aee333308fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b8f3cc4184af374c52649be9f69f308dd657149f99b37339b7bfe607d6b8d16"
    sha256 cellar: :any_skip_relocation, sonoma:         "f1a79a9975c1bac4afb048b031902b6cca2c25f8a3735a6e252c0599ed635ddc"
    sha256 cellar: :any_skip_relocation, ventura:        "51fe1f925341c411a768197d9970fa111c28d022242b66aec86ab093490dd268"
    sha256 cellar: :any_skip_relocation, monterey:       "dfcfa973942e8701146cdaaa71ee04dc5a5fb4305852c6a87ae85083f8c5783a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0faa5295db3018d66300b90517ca47c0e16866bbc848c74755c96c57e2840d0"
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