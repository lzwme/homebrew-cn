class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.97.tar.gz"
  sha256 "eefd9b53e3d2760ddd35e3ac654ddfe342c0c5f59cfa61b0489f68efef46c65e"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "588f59dea4d58ec1dbedf9b183e722e2755238380bbf4ef0ce677363f943f83e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "588f59dea4d58ec1dbedf9b183e722e2755238380bbf4ef0ce677363f943f83e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "588f59dea4d58ec1dbedf9b183e722e2755238380bbf4ef0ce677363f943f83e"
    sha256 cellar: :any_skip_relocation, sonoma:        "607e4ccf6f5ff13d868fc8e4fb01b4d75a7b8f77737177778f4eb4e62affc94b"
    sha256 cellar: :any_skip_relocation, ventura:       "607e4ccf6f5ff13d868fc8e4fb01b4d75a7b8f77737177778f4eb4e62affc94b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ea810b3f8638b0d9377145215797fd9bc098faf26a72ae659d72722f6e10d79"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.builtBy=#{tap.user}"

    system "go", "build", *std_go_args(ldflags:, output: bin"kubectl-testkube"), ".cmdkubectl-testkube"
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