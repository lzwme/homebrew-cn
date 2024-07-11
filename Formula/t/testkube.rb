class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.0.7.tar.gz"
  sha256 "77b1bfea47847d373cbbeedace719d0bea87d6bcbf63144c141ad0a3940ce2eb"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dbb37de908ac1b66545e96ccf0cb3104cfbdf33e2f23243f29ea9c43b2dbf5af"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a6ffd04deaa5eb47fd6077b7547df180894c652b45d706a0730af5573ba0cf4c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "afdb30fa0f494fe760f2977a52f1c3f1941410f3b473ada1edece9dd3cde6b54"
    sha256 cellar: :any_skip_relocation, sonoma:         "c452012a8c694b85b48d72f60495a92234ec123354484ac4730716a5599e2000"
    sha256 cellar: :any_skip_relocation, ventura:        "c980ccfcfde7ef86334761213de2f539db99570ff3e22d92a6cd9e5c873b8e72"
    sha256 cellar: :any_skip_relocation, monterey:       "15ba19b7e50d14d543a08d4459621ea3c3051d444c7e301f0dd23d631ccd6801"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ee1ab97e805d879f174dea956d8d0298ca8738a143f3bbd541c30c2b38c9d3c"
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