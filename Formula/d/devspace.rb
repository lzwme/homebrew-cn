class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.sh/"
  url "https://github.com/loft-sh/devspace.git",
      tag:      "v6.3.6",
      revision: "79fa51df13f2a84691e9716e91aafdbbcaa74e42"
  license "Apache-2.0"
  head "https://github.com/loft-sh/devspace.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2b312443a5a3f07fe42da012ed61bdfa2bb78256a10ea4a063093342440c99d2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "19c7167745fa7d0978d2655f506167ac728f1c72adc72fe5de3ad644a06aab56"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ebce778e91666c19fe9af28483f4c4b007f66204053ea3688a01237ab623016"
    sha256 cellar: :any_skip_relocation, sonoma:         "5cc98175df0cc8b424fc6a7215324964568abce62971ab2510d67b1712bc7e00"
    sha256 cellar: :any_skip_relocation, ventura:        "bc484c1537e8ff8a9757ff9cbb57f2e71fddf5e675ed0bafaf157a1dd9489f91"
    sha256 cellar: :any_skip_relocation, monterey:       "eaae69831b0386f390d5fdd5b0a106b5cb4cffd5bc687d9054cdb5d5da2c96a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff0055fc53a908bc0c6917ac8eb8789d4cb3dfe36bd28341d5f017db3b6553e9"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ldflags = %W[
      -s -w
      -X main.commitHash=#{Utils.git_head}
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"devspace", "completion")
  end

  test do
    help_output = "DevSpace accelerates developing, deploying and debugging applications with Docker and Kubernetes."
    assert_match help_output, shell_output("#{bin}/devspace --help")

    init_help_output = "Initializes a new devspace project"
    assert_match init_help_output, shell_output("#{bin}/devspace init --help")
  end
end