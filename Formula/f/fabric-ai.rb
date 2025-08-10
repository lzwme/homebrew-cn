class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://danielmiessler.com/p/fabric-origin-story"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.278.tar.gz"
  sha256 "ca0ab05f317f6d18befe6398fa2c1d36ffa793f147a86208a0b2e34df38bc048"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d39c69baccff6f20bcbf10b201b732dfeea3cdcd0b63241d61e195113817b5e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d39c69baccff6f20bcbf10b201b732dfeea3cdcd0b63241d61e195113817b5e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d39c69baccff6f20bcbf10b201b732dfeea3cdcd0b63241d61e195113817b5e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "ffff7a5df69e70ee9ab1828a8fe2e18f50db27413b06d7aaab98d2846c3d2547"
    sha256 cellar: :any_skip_relocation, ventura:       "ffff7a5df69e70ee9ab1828a8fe2e18f50db27413b06d7aaab98d2846c3d2547"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ce4e0f0823566cd479485425c8f115f78d36fa115f0e50a5acb1d4c0d255ff0"
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