class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.0.14.tar.gz"
  sha256 "af2859315490841e9a533ae869f377ae7dc29027a1a78e5273e006302f889223"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0f5c08de39b34c5e1bf37b6f21016b71c4b4e41f7b9f05fc3a9b49d4dda70e48"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "21d417527bfb048bfea438f4d61aa40d653c7069471e46baf372b25a1901e71b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3157e26f8954ec505f9501c1ca29695932abccc46b82365c50d2fa2fffc73b19"
    sha256 cellar: :any_skip_relocation, sonoma:         "332f4ec0aab92f73e720148d2cdf8e4238b2c738b0d3381fafb712ace3c1d261"
    sha256 cellar: :any_skip_relocation, ventura:        "da9ed75efbba8fc3acaea16eaf5c9a3598512f017185ee10838325c4a9d45e9c"
    sha256 cellar: :any_skip_relocation, monterey:       "bb46672515504c5e9e6ecd95f140168c7021967690b120e88ba682a77eed53be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06c218f0805b20804b87c1967897a32a3c52c2124969e6ad723e5703d8b8aed4"
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