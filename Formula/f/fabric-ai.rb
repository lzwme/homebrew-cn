class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://danielmiessler.com/p/fabric-origin-story"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.265.tar.gz"
  sha256 "cbb021d4cdb202e6ff6ce40c470ca9ae9f80e633b87d130756cd8e9c575f4f08"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10da1ce7135e3e51571cdf1556059dc9c3ddba42d7bfde795187f4bb45f69f71"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10da1ce7135e3e51571cdf1556059dc9c3ddba42d7bfde795187f4bb45f69f71"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "10da1ce7135e3e51571cdf1556059dc9c3ddba42d7bfde795187f4bb45f69f71"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc266f88c4f527a06a1f3e43e48bb31262c1acee39c5cc6b38a4cfaf84c22803"
    sha256 cellar: :any_skip_relocation, ventura:       "cc266f88c4f527a06a1f3e43e48bb31262c1acee39c5cc6b38a4cfaf84c22803"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5b21687042f65ec3986651e2859951e1f4a64fe4a4419aa0047d69516b00b23"
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