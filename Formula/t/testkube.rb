class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv1.17.30.tar.gz"
  sha256 "e25af4f5129363c5139defe388ad240c00ad94a33e7e690854e4cbae41380276"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "991762f3848ad26206eb836e7f036e2cf314d3b967b8ab9a11d368b7d7712e29"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "42f8b91d7fc2134a831afbd2b47be0dd3e5dc30638d265b4305e2f49ddda6765"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "429174b6fac28b0362b4bbefbbe705c2847d4cca872f89abdf62fe1dd68e0d8b"
    sha256 cellar: :any_skip_relocation, sonoma:         "1d8cb4ea897e2ac9b9f74c4cfc102770845fd12c10719b68fc9970fe8325906e"
    sha256 cellar: :any_skip_relocation, ventura:        "76fe9d87f227b69b6834ff891055b4c3121e1b5bc4fa10480297db8cf230cd11"
    sha256 cellar: :any_skip_relocation, monterey:       "de677fd0c186dd20e68176254c1501133f4b5ff6562b54a648438c46e6a1ac2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "943e30056054298f90b50aceb63f02e7c871be97687ac9ae7b6c7c0d03185c48"
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