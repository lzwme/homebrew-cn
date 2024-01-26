class Devspace < Formula
  desc "CLI helps developdeploydebug apps with Docker and k8s"
  homepage "https:devspace.sh"
  url "https:github.comloft-shdevspace.git",
      tag:      "v6.3.10",
      revision: "af45484dbe239b1587161def4c4799a7ca6d0ef3"
  license "Apache-2.0"
  head "https:github.comloft-shdevspace.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "174adac38b847ced4abd4db317f08bfab2d756162493c56967183c65dd547aa3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "abcff2c8eceb5b06b0201cf5eb954734bb6175fec66cb684ea2bdf8150679d76"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b0ff3277c259546736fb0b064860b529f3255e32e1aff44ce38191928aac71d4"
    sha256 cellar: :any_skip_relocation, sonoma:         "c881a6a95ea322f8689ddb8792dbfb4fd0b23209513d542a28ae9bdd3dcb4d9b"
    sha256 cellar: :any_skip_relocation, ventura:        "e59d3611ed42991b520ec6093884f63f0fd28183d4f7d216c844bc1fd56ce4b9"
    sha256 cellar: :any_skip_relocation, monterey:       "c0dcdcb0af01ee09772aca2db5dfbc98006c453f4074f251b31a0e449a321de1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "abeb9717a72887bd9c98eeacf613bf26bb64713f361a26bd20a7ca8c1809895d"
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