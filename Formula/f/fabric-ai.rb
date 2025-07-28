class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://danielmiessler.com/p/fabric-origin-story"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.270.tar.gz"
  sha256 "3aac3088484aa430d40a7faf3f0ad57d4beb1c4448fa93729fcb577185fa0cf8"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a1b0c745aac0cd81f44ab37c45b30b9db30734e53e1d54205ab1775d45c921a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a1b0c745aac0cd81f44ab37c45b30b9db30734e53e1d54205ab1775d45c921a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9a1b0c745aac0cd81f44ab37c45b30b9db30734e53e1d54205ab1775d45c921a"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0a005cd2a28d1d6006a3bd27056236520d19cdcc463222c118421e2721fc006"
    sha256 cellar: :any_skip_relocation, ventura:       "e0a005cd2a28d1d6006a3bd27056236520d19cdcc463222c118421e2721fc006"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbb81b21f8972db71b497dc70d3fcc664da78b993452f07e31fa6e1380fe4413"
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