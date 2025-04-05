class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.136.tar.gz"
  sha256 "36aa211cfe0ce0c66f2dc06061f3a8dbdb3d2ef128907eb35ef611dc6f186947"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3cc8fb27920ae79bb7fdc58bd92128561b4322dff9154c7c166d23009fabacb6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3cc8fb27920ae79bb7fdc58bd92128561b4322dff9154c7c166d23009fabacb6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3cc8fb27920ae79bb7fdc58bd92128561b4322dff9154c7c166d23009fabacb6"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd9a5daf5d5c8b87da472bc4acff4ba19f43608c2afde2d931415e38c9abeaae"
    sha256 cellar: :any_skip_relocation, ventura:       "cd9a5daf5d5c8b87da472bc4acff4ba19f43608c2afde2d931415e38c9abeaae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6fe9fbbfa9618f44d56def3c1e348055eac3c8237221adcc2eb7afb35fd53a7"
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