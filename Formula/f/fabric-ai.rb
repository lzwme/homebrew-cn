class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://danielmiessler.com/p/fabric-origin-story"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.263.tar.gz"
  sha256 "050713447824d78443226a7e5daf6cdb62fe364de0521ff89e5bcba28b0a651e"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8bd885c33a68ae6a460f7498b30e39c52c792e58006022df618446090e02cd5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8bd885c33a68ae6a460f7498b30e39c52c792e58006022df618446090e02cd5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f8bd885c33a68ae6a460f7498b30e39c52c792e58006022df618446090e02cd5"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa2378aa5aac7e89ca8f2641711b999c9ce6202168cfe3ef945364958311c53c"
    sha256 cellar: :any_skip_relocation, ventura:       "aa2378aa5aac7e89ca8f2641711b999c9ce6202168cfe3ef945364958311c53c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b5f59c49788bb07141ea8b7cae1f17a5a03df0b76d20d15d3f4951137568e18"
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