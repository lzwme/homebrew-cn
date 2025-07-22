class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.16.0",
      revision: "0011378256eb8c63b6d4fab6dfb1fd8634727369"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "438b1cc09ada1378444801b78880a6eebcb5e301984078136b8194b536b68f84"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4210f248db5509f4cf0b7f912edf82adcd61b58b46e0012c3273d6102818104"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a59e837f3f3ca9bd980a34936574bb42d55f2f4987742a36a24b35949124838a"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1b637c4c964f5c736d68f721b88f1f384f31e35bde22b30935bc59c73035817"
    sha256 cellar: :any_skip_relocation, ventura:       "f4263553dff1727ded7b432fcf4c4383e9e0debcf7bfdcc62cc297234333a48a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4d90e0fc53188d360567b7109281cf59c9f39ffb41abf93b1a7be4853ed529e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65bd1659a25365ade84470b93b9c68bb8dbdc87e412a427a662c1c59ba21422a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/yoke"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yoke version")

    assert_match "failed to build k8 config", shell_output("#{bin}/yoke inspect 2>&1", 1)
  end
end