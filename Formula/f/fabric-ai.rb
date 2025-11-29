class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.335.tar.gz"
  sha256 "3d84dbe6d3e1039a4f8b00f29e74a20a3c4db725484cac3c0913d05adab98577"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c9d656a0101dced28a98eb3dc84511c1c4ba5cb9c3cb2ee08f2b597143dd3349"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c9d656a0101dced28a98eb3dc84511c1c4ba5cb9c3cb2ee08f2b597143dd3349"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9d656a0101dced28a98eb3dc84511c1c4ba5cb9c3cb2ee08f2b597143dd3349"
    sha256 cellar: :any_skip_relocation, sonoma:        "97bacb95e2a264827ef27fc0971e301d3472f52f0f6fea01b4b3c9fe669d0b3d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78f8038291f411d3dc297355396fc137adce1c22a36a2d38128711fcfd8527c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91dfa8453dfaf591f87d5b08ec56f0fe5362a0df6000332739ab0864aea1631a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/fabric"
    # Install completions
    bash_completion.install "completions/fabric.bash" => "fabric-ai"
    fish_completion.install "completions/fabric.fish" => "fabric-ai.fish"
    zsh_completion.install "completions/_fabric" => "_fabric-ai"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fabric-ai --version")

    (testpath/".config/fabric/.env").write("t\n")
    output = pipe_output("#{bin}/fabric-ai --dry-run 2>&1", "", 1)
    assert_match "error loading .env file: unexpected character", output
  end
end