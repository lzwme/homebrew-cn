class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv1.17.62.tar.gz"
  sha256 "cc2fe79b237595ca145a1acf9ec61f93c21c9dd2c929409a67e0bb8f7c11c7ac"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "36bf8663a97789bd79dd1dbec41586afa888af66aba53f459a354062acff2273"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b12604e544da3a2c4c80c53b58d52f54e16611c97d4c0183fbf155480a4cf24b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d018bcd85147c5278539bf97cf7e943e2b5e90eaa1366e2084834a92cc7934ca"
    sha256 cellar: :any_skip_relocation, sonoma:         "05604affd6cbba941d640bfa5d481b7e3b0c60927c1ebc228c6c7b5a457ba05d"
    sha256 cellar: :any_skip_relocation, ventura:        "4e1e4f026fa3358b5bd800f049d6571eee813c49b46e2069fc03eb458b6dc2e1"
    sha256 cellar: :any_skip_relocation, monterey:       "4eed63b5ba85e655d88d2bf48f47e4149b3969f9aae095c80f1a9e2f2e8c6a5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e96e00f15e470e0f22cb207b19d8d2f7a32a070b223b7dcb47ea320480d31b85"
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