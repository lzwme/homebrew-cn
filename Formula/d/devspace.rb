class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.sh/"
  url "https://github.com/loft-sh/devspace.git",
      tag:      "v6.3.5",
      revision: "bc3af8de76e9820c11b45c222ebecb96166cafc2"
  license "Apache-2.0"
  head "https://github.com/loft-sh/devspace.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "964bacd0be94726a775dd0ef6aa1847d18941eed3170daac7a160750ec22603a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d93496f8879626a6f2cb9d70242d6e6fbc2ddad66c93dc6aff59a895c3127450"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09bfdfb6893b1e92b3e3d67b5db33e1f6b0085c2dc98b32f7f310d54b10394c6"
    sha256 cellar: :any_skip_relocation, sonoma:         "ea81bb5d587ae4b85f11fe8cc73a737dbeb6c25ed178995d53d653cf08bd1475"
    sha256 cellar: :any_skip_relocation, ventura:        "1d1beb77e833b04e97430026d689b3a65ebd0549b99cedcd7cf6a492b566191a"
    sha256 cellar: :any_skip_relocation, monterey:       "29d1988627cc55be29c41ad7250c38c68660f7994376ee0fc52c733d3aeeb6fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "889a2661667505c6b39252acb1e476e96e987236b82e621a7350763b9efd6a19"
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