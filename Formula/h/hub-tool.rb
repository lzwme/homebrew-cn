class HubTool < Formula
  desc "Docker Hub experimental CLI tool"
  homepage "https:github.comdockerhub-tool"
  url "https:github.comdockerhub-toolarchiverefstagsv0.4.6.tar.gz"
  sha256 "930f85b42f453628db6a407730eb690f79655e6c1e5c3337293a14b28d27c33a"
  license "Apache-2.0"
  head "https:github.comdockerhub-tool.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "383679a6456865f5e36b0d710ae259fca5057cba48f81fdccc0d03a197744806"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "383679a6456865f5e36b0d710ae259fca5057cba48f81fdccc0d03a197744806"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "383679a6456865f5e36b0d710ae259fca5057cba48f81fdccc0d03a197744806"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e0722508d39f391bf7f7817a4ef1ff719fce73214a142168c08a67a9ef415f1"
    sha256 cellar: :any_skip_relocation, ventura:       "2e0722508d39f391bf7f7817a4ef1ff719fce73214a142168c08a67a9ef415f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e083aecad14ea1110da6ed9679e67b27968203768977396d1fb2c78861523787"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comdockerhub-toolinternal.Version=#{version}
      -X github.comdockerhub-toolinternal.GitCommit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}hub-tool version")
    output = shell_output("#{bin}hub-tool token 2>&1", 1)
    assert_match "You need to be logged in to Docker Hub to use this tool", output
  end
end