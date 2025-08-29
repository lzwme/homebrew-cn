class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.302.tar.gz"
  sha256 "3bbf24f35a343d5fb69be2ddab085ccf7e868af04f7c3cf33f559d07fe0e8ac5"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cbc992e8b15379f49e43f636209816b016604d66e7264a0bd44d14daf44a4fba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cbc992e8b15379f49e43f636209816b016604d66e7264a0bd44d14daf44a4fba"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cbc992e8b15379f49e43f636209816b016604d66e7264a0bd44d14daf44a4fba"
    sha256 cellar: :any_skip_relocation, sonoma:        "fee3fdb832bbc5689ffabcb89dab5c96b66f87c68de0556d4924e6847f4852b7"
    sha256 cellar: :any_skip_relocation, ventura:       "fee3fdb832bbc5689ffabcb89dab5c96b66f87c68de0556d4924e6847f4852b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32bdabf3a830bb12980b0f5b13d7dec2a0fb4d98ec909adefdb016b2c1608da0"
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