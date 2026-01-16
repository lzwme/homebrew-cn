class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.379.tar.gz"
  sha256 "281761474c8604fa6072881eb4582a1044202d9db2b047940aa84c54b2ce0d6c"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d8f42bffc36e9c8112b80a5bfcecfa1655ae531dc980e10f682580f76881a87e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8f42bffc36e9c8112b80a5bfcecfa1655ae531dc980e10f682580f76881a87e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8f42bffc36e9c8112b80a5bfcecfa1655ae531dc980e10f682580f76881a87e"
    sha256 cellar: :any_skip_relocation, sonoma:        "347d7142b8a45c3a5c8e3d4f1dcecf90ed6beb7f3d60487ff5d7c3fb01504035"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc3f5553e68a2e9da237ebcb94e7dd2148dffd07435cf3b33b70e068cfa6f930"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ea4b01dade3cead410783c4ca285d2df9814507cb753c4b4f94449d4fff2e9b"
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