class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv1.17.26.tar.gz"
  sha256 "978bb3d7def50d16ef3e3269b91821d3dfd09945463b857f56e5c4457ecf49e4"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "032fc6bdc852844355ca96527d9f3d56edf70c941c69fc9f10d9d402b9907334"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a2b3dc41a1b82cb4a29616a9a97e632aa7ecde2fc044866f2327a8bc0d2c9909"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0db21f064f3f1bac67483f06b0e8ee3f9af29ad33371418672b2a176237f30fc"
    sha256 cellar: :any_skip_relocation, sonoma:         "0bccdc0f4b21dcb1d319f2079cc68e7529252ee77555e6d04187fefac293e0fb"
    sha256 cellar: :any_skip_relocation, ventura:        "3125fb372f54b837f59a5df04ac56c5c0f9c60d2b9a11598cdf3f661ee4562d1"
    sha256 cellar: :any_skip_relocation, monterey:       "40bb7767ff7709331dad33eed45e8b87d2f5312c8eef19c54a3f5e6f3cade011"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d11470aae6a4bebd2646fd30e52443250aeb4fa35249fe230c01d23db276054"
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