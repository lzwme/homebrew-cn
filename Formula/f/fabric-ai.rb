class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.365.tar.gz"
  sha256 "9ab0a4e0b312762de7163d1022e9046ddf68003fa1705c2b607ff7e41ea3fe19"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10d2a0f8a9833429888e779254441ca582ee58e74c570263d2f0edb2bd2380de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10d2a0f8a9833429888e779254441ca582ee58e74c570263d2f0edb2bd2380de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10d2a0f8a9833429888e779254441ca582ee58e74c570263d2f0edb2bd2380de"
    sha256 cellar: :any_skip_relocation, sonoma:        "58cb2e892b489a6716d750e3319e07ab2ad6ce62ab98a92be664a83229eb6f11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6208f2250a00dc52c5ff5fc785e70d1d47bab9512f6e490a2de24a8d5a881032"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "001cd2aa091f377a6e4063a411e41484183f671d56b4f820ed9dc9964f88eb4d"
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