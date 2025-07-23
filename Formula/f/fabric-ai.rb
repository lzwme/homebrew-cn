class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://danielmiessler.com/p/fabric-origin-story"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.264.tar.gz"
  sha256 "fa4e13de58ad145d334a0836d5a1f074191b0740a7f7d0451ae9cf257083dde9"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1ec09fd0056c4fccde4b0809578688b599a59752e0455b8ff25d675c60910e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1ec09fd0056c4fccde4b0809578688b599a59752e0455b8ff25d675c60910e6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a1ec09fd0056c4fccde4b0809578688b599a59752e0455b8ff25d675c60910e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "131e02cb165e9f9f055da4e33af8d2de4f1dfa1db7e70767e7e8e7a885cce60e"
    sha256 cellar: :any_skip_relocation, ventura:       "131e02cb165e9f9f055da4e33af8d2de4f1dfa1db7e70767e7e8e7a885cce60e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36a9f9e779d1d9aaee03e551c3a13652435328a730a921f8949fd0714757ee9d"
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