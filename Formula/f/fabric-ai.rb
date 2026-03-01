class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.425.tar.gz"
  sha256 "57966e3d90308b98ba3417fa6d93e4cd3d56b04b70c4b099da2bcc0df694d44a"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "843233d04fbef8f79cf72e3e7a49a3183e085853fe6b8d998542d8b8b8fa73f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "843233d04fbef8f79cf72e3e7a49a3183e085853fe6b8d998542d8b8b8fa73f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "843233d04fbef8f79cf72e3e7a49a3183e085853fe6b8d998542d8b8b8fa73f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec555607712ab674f84547b6278c9e2850863006de65528ca593b6f92475b1c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "187030dd556c393e0de0db183570a449271b6da91455b443a90fd0447eca68dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e49599260d32e70fc21c70fca5200c24aa7769243d79e30b41bc1861cfb5a8a"
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