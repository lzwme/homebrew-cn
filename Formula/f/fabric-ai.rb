class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.397.tar.gz"
  sha256 "173ce911fa4eb0f4193e247300f895a25e4736bffd21ff7f6d23609ba1ea6326"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "16cde6d211a91cf05984fafb4ffc96e090db3a4c9dc7490b3ed1b4e83cdffc96"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16cde6d211a91cf05984fafb4ffc96e090db3a4c9dc7490b3ed1b4e83cdffc96"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16cde6d211a91cf05984fafb4ffc96e090db3a4c9dc7490b3ed1b4e83cdffc96"
    sha256 cellar: :any_skip_relocation, sonoma:        "e925d978f81cde803fb6a781e279b870472962bc7f573022c4ccfc03e9187164"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "583d86f0e4c1c1a141a82b391cbc549237ff2c2b961f32c95cd1296589e7a6fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61f0a69ad6e07948c5a8a080d4345394613ab1bc1b639eecf3d22ab1d3c70ef3"
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