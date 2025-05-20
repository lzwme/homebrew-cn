class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https:danielmiessler.compfabric-origin-story"
  url "https:github.comdanielmiesslerfabricarchiverefstagsv1.4.189.tar.gz"
  sha256 "7a18411134a6fdb311c161d867beff4355234921b8b80a46e044f8e130892b68"
  license "MIT"
  head "https:github.comdanielmiesslerfabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "965d608f24f8d5221e15d5c73918855593226d4ddb7f25b7f80a324fd1252114"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "965d608f24f8d5221e15d5c73918855593226d4ddb7f25b7f80a324fd1252114"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "965d608f24f8d5221e15d5c73918855593226d4ddb7f25b7f80a324fd1252114"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed37d83789abfd16729682ea4b0263c37d957855ada7f3d78a2667ae78bfe810"
    sha256 cellar: :any_skip_relocation, ventura:       "ed37d83789abfd16729682ea4b0263c37d957855ada7f3d78a2667ae78bfe810"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff6f3cbb1acb40308e2e1f7fb3a6b04accd7b16d46f04457bf1c6daa25cfbc6d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}fabric-ai --version")

    (testpath".configfabric.env").write("t\n")
    output = shell_output("#{bin}fabric-ai --dry-run < devnull 2>&1")
    assert_match "error loading .env file: unexpected character", output
  end
end