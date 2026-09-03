class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.474.tar.gz"
  sha256 "838ecc6ff069f750dcf4361e7ce393beb7624b41173981fc407bc3755ef3b317"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cdd4be838eaf29a8e6c77f08d531a91684b1dfaef6df90f305e8c8810ab23fb1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cdd4be838eaf29a8e6c77f08d531a91684b1dfaef6df90f305e8c8810ab23fb1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cdd4be838eaf29a8e6c77f08d531a91684b1dfaef6df90f305e8c8810ab23fb1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "68d3037a91fe81ecbf6153cee32d2e24db39ffa99b9fa84fbb685016f298c17c"
    sha256 cellar: :any,                 x86_64_linux:  "7723bc489c4fff2912611949e4265cee77b0f4feebe18f91de7e8d0a05f07fda"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/fabric"
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