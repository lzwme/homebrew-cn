class Devspace < Formula
  desc "CLI helps developdeploydebug apps with Docker and k8s"
  homepage "https:devspace.sh"
  url "https:github.comloft-shdevspace.git",
      tag:      "v6.3.9",
      revision: "b21c769305d619de6eca42ec58e08c2e757cdc78"
  license "Apache-2.0"
  head "https:github.comloft-shdevspace.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "34b9edf90778dcbf5333c5a204973d31a46f86da91ea0c615c7f7209b439aa45"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c6ff1816037028d07a22d839ff350ca498acb31667817e1bb3499f4de09b149"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4973b1f8226b5912e4416e55150133941b7b0d4bbd4c2f679a9972c36e5b0dd1"
    sha256 cellar: :any_skip_relocation, sonoma:         "7704a6ff747aafcd9ef752d51e09815685d81e3de45b4fa5715483c99709e343"
    sha256 cellar: :any_skip_relocation, ventura:        "87a96e1b7b9392d7ef9f3bfb8e2c1cab2e8d108d615b455197a38389a8aaa7ae"
    sha256 cellar: :any_skip_relocation, monterey:       "42b1e86c2e079d89f9c6a3c23048a469c4b2fe1eb15e8483af6439663ba43e4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2fd32935455e9e2c815a27fc731a3b69f1c9840a954784cbb1e285c660d7e2d5"
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

    generate_completions_from_executable(bin"devspace", "completion")
  end

  test do
    help_output = "DevSpace accelerates developing, deploying and debugging applications with Docker and Kubernetes."
    assert_match help_output, shell_output("#{bin}devspace --help")

    init_help_output = "Initializes a new devspace project"
    assert_match init_help_output, shell_output("#{bin}devspace init --help")
  end
end