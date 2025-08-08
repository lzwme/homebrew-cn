class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://danielmiessler.com/p/fabric-origin-story"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.275.tar.gz"
  sha256 "f39e004a2e7c04f2df8759be477b43df37b7fb685210abb5b4f7e08be9da9baa"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f885abf704d803d1c391c9bf6f455e0b1231f52bea55eb001876fc97ec6e4b8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f885abf704d803d1c391c9bf6f455e0b1231f52bea55eb001876fc97ec6e4b8f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f885abf704d803d1c391c9bf6f455e0b1231f52bea55eb001876fc97ec6e4b8f"
    sha256 cellar: :any_skip_relocation, sonoma:        "56b67d3b21d1a032e8242ba29581e3e76434167530419723598304f76435bdea"
    sha256 cellar: :any_skip_relocation, ventura:       "56b67d3b21d1a032e8242ba29581e3e76434167530419723598304f76435bdea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54ea7a6bf5b37b61da6f65ee194fa485bd26b549ae8581e502744d9fe0d4fe22"
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