class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://danielmiessler.com/p/fabric-origin-story"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.286.tar.gz"
  sha256 "e8d6b52f445737e79e9b483ccc95470c93874818dc173ac6efecab21489c7eac"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87e02c98f123c755acaf1a85d8d15801a503a9ffa89e6c89548770c9ecd59b76"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87e02c98f123c755acaf1a85d8d15801a503a9ffa89e6c89548770c9ecd59b76"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "87e02c98f123c755acaf1a85d8d15801a503a9ffa89e6c89548770c9ecd59b76"
    sha256 cellar: :any_skip_relocation, sonoma:        "aab9d114f5c0ab1960357461751b8edded8e76ed912172f5b4b76b5965480dfe"
    sha256 cellar: :any_skip_relocation, ventura:       "aab9d114f5c0ab1960357461751b8edded8e76ed912172f5b4b76b5965480dfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6cc4471ec00c87b8cc0e554957a627b557fcb36ee3864bb0aea116d9425f81d5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/fabric"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fabric-ai --version")

    (testpath/".config/fabric/.env").write("t\n")
    output = pipe_output("#{bin}/fabric-ai --dry-run 2>&1", "", 1)
    assert_match "error loading .env file: unexpected character", output
  end
end