class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.83.tar.gz"
  sha256 "a20b266b52ff7b0616261a1cbfba151225e4efeac05e4303e1e20c68b69f8b5f"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f542452014b9493449c91d7b77de64a07c7071a1256e465a7d8eb1f82c92e9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f542452014b9493449c91d7b77de64a07c7071a1256e465a7d8eb1f82c92e9d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7f542452014b9493449c91d7b77de64a07c7071a1256e465a7d8eb1f82c92e9d"
    sha256 cellar: :any_skip_relocation, sonoma:        "669047fecce82f6032a4690e22fdd72629c9eac8445aac602ba005f663ea118b"
    sha256 cellar: :any_skip_relocation, ventura:       "669047fecce82f6032a4690e22fdd72629c9eac8445aac602ba005f663ea118b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74b1b247eff7062fa02b0b37396d9e331ebb22cfb404057fd7704b1925844204"
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