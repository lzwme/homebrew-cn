class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.417.tar.gz"
  sha256 "994746484fc4759fc39f2c70e8c33f868294ed75ea5b4ce5b00233807dab3f79"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "98ad89cc37c3ea96f931af1fdfa4ae8ae4c6e57115cb3affe1573380529b171b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "98ad89cc37c3ea96f931af1fdfa4ae8ae4c6e57115cb3affe1573380529b171b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "98ad89cc37c3ea96f931af1fdfa4ae8ae4c6e57115cb3affe1573380529b171b"
    sha256 cellar: :any_skip_relocation, sonoma:        "bce45ba4295b32d7ebb4f0e5a17a02315b1e3c533010047b497be0e447039896"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2fc29f9d90907c0c8cec85ee63c4a7a87b2682bdc86c575d949e0d16763b61b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a07870c0f5dc79abe0b0b1dff73ab2a908b99dc3babe28a9e9ce146daaf8eca"
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