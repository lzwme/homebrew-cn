class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv1.17.37.tar.gz"
  sha256 "6625784d4edcc40d3dbf573e995638425cd4097d23fae965b4a73a6f768576c1"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1cefbd07277e71fd080a9b0696eeb62ca1bed2f7262f827e2119a41dd6b0eab2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5619f55f32b6790adc2549ee05180570db664efad2481e47465407cbf755886b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ba0e6e698742a5bbfe772f0f34acf9a1e2438915a8dbef6b9b713fe2bedbecc"
    sha256 cellar: :any_skip_relocation, sonoma:         "5f75565906f3e4d2584ce1c41b4ebf7281221c24b5c712f3464954db651c395d"
    sha256 cellar: :any_skip_relocation, ventura:        "c93ab3b5aa1b3d15e6b94b5a740b6a1b4e8356e15be8102141e46ce5e71935de"
    sha256 cellar: :any_skip_relocation, monterey:       "0afe48085f64d2a9d1f9f7440b3b3f19a10228e233abc5ca2804122627ba7b7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b89e1575ec07db97f0c15952eefc12cd1018f55f15e4beb9e82a2834378072d1"
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