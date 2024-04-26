class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv1.17.18.tar.gz"
  sha256 "e2ca46b9930b4751f64000aed91671fc0c1ffb34be5c1e442dc1d24568556f37"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "65ed6caa76c60c37fdb07493f25cb3090f1d2441e7f4c085095d757e5656fff9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "01aafc59657565caea8f41b9d83d661d889364e4323613fb8e0521d4dcc15981"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "842082ec83daceb95ec68dbc18d46f64d0e4deccbb7fafc91652c8c7c95d31c5"
    sha256 cellar: :any_skip_relocation, sonoma:         "49490d04a9cee78e71b2b0b4ee030e72fae8a57384cbe69314f960ee0facf63c"
    sha256 cellar: :any_skip_relocation, ventura:        "86eedfbeb489d013d54f2ab735fc212dfa746b4863e50e704b012477fde6e69f"
    sha256 cellar: :any_skip_relocation, monterey:       "da189eb92a258fab32d5e8a79c0c6b2b32ff785af366d5da1669777e987b4ff4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "803e601f954aa0dcb6667f026844f25d367fe0dfa3ead0b0e13f610c15d59c69"
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