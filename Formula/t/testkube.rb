class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.9.tar.gz"
  sha256 "6a51b8d53777dbbe7f96faf90306d9dea7d6002cf24630f7ad49d5ebca818a68"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "96fdb187aecab8ba4f57d69af398809da8dfc6d3d4f9cdd68dd0cd272785387f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "96fdb187aecab8ba4f57d69af398809da8dfc6d3d4f9cdd68dd0cd272785387f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "96fdb187aecab8ba4f57d69af398809da8dfc6d3d4f9cdd68dd0cd272785387f"
    sha256 cellar: :any_skip_relocation, sonoma:         "a2dcb79b77f5fdb657940cd23095bab31608fb721bc1b272e0e62e9e1262010c"
    sha256 cellar: :any_skip_relocation, ventura:        "a2dcb79b77f5fdb657940cd23095bab31608fb721bc1b272e0e62e9e1262010c"
    sha256 cellar: :any_skip_relocation, monterey:       "a2dcb79b77f5fdb657940cd23095bab31608fb721bc1b272e0e62e9e1262010c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7cef108ae08c08a9caac220cac77ed4f55ae87a6cf1df46dc10f7454ec91efe0"
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