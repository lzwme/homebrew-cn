class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.351.tar.gz"
  sha256 "8c8c7830ddec127853c31ecd6aae4e7296d870cf07c5a0eda89ac7b42b01a183"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e6cacbc4c6696f13b1c64d031ab5a21c93757492e119255b36c574c9400a2129"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6cacbc4c6696f13b1c64d031ab5a21c93757492e119255b36c574c9400a2129"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e6cacbc4c6696f13b1c64d031ab5a21c93757492e119255b36c574c9400a2129"
    sha256 cellar: :any_skip_relocation, sonoma:        "8cf741e480f3a2990f70f1ae9b26abca900adaa55dbf780512121d8f731c2721"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d96768641bd373c58dece3a683e37eeaa4bf2f0d14487a117fa01c951b6f5980"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ff3daf9ef87e58393e31341ac07c4052278912c55eb28ec8d5a9ed08708865d"
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