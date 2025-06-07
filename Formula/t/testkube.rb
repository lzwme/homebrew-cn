class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.157.tar.gz"
  sha256 "d61ee95059f21eb6277472256d0790dc915f1f8aa2b7fe3fbcbe6396fcb3249e"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7424a1a2c136811a73ee95308ce6a7e55bed9f64cfe7b4db619b8b72faba6fbf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7424a1a2c136811a73ee95308ce6a7e55bed9f64cfe7b4db619b8b72faba6fbf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7424a1a2c136811a73ee95308ce6a7e55bed9f64cfe7b4db619b8b72faba6fbf"
    sha256 cellar: :any_skip_relocation, sonoma:        "b4dcc286606862e51458dd4dd59f467a93c4df3f8410b04a88407a579952ca28"
    sha256 cellar: :any_skip_relocation, ventura:       "b4dcc286606862e51458dd4dd59f467a93c4df3f8410b04a88407a579952ca28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5578b20beca2ee1aa6c7446ebb50449a32955c5378612dc86c3d872bb79c33de"
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