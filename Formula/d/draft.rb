class Draft < Formula
  desc "Day 0 tool for getting your app on Kubernetes fast"
  homepage "https:github.comAzuredraft"
  url "https:github.comAzuredraftarchiverefstagsv0.0.40.tar.gz"
  sha256 "4fa8c9452ace26d6045ac846ff848766e4312ecff6e6c15019fc7b48984e5650"
  license "MIT"
  head "https:github.comAzuredraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "167d4fc234d50ff4d7fb577441004fcdf58288c9a46acdf6418f77d79ccad4ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da21c146ec57b790192674734a24eab97c142be03d0958d3d4cfe01af005ed61"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "be898735a11267cd48697337802580735dc5f0fde2c7a69dad0e4353243f66fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "766c036d3ef80d2ce2a360647cb5f2de3ee1d76d7e5a7bbf63a8b60b8eec5402"
    sha256 cellar: :any_skip_relocation, ventura:       "d79d6a89ea6f283463cc5a9fc83b6f3853164fc80d1bd88e22b06fea6a079973"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71a934178fba72d8188396aad301c88f0a090b5dc7fb132e2c23c4f874eb4ed5"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comAzuredraftcmd.VERSION=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"draft", "completion")
  end

  test do
    supported_deployment_types = JSON.parse(shell_output("#{bin}draft info"))["supportedDeploymentTypes"]
    assert_equal ["helm", "kustomize", "manifests"], supported_deployment_types

    assert_match version.to_s, shell_output("#{bin}draft version")
  end
end