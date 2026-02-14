class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.404.tar.gz"
  sha256 "446704b5577f4e5c40c5bf760ceeb4a93033ea0d3cc73c67c9d134170d8fe593"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "44592df67dc7cd9bdd5bc3df03c8de0fffdad06b76c0cfab73ede972cb875740"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44592df67dc7cd9bdd5bc3df03c8de0fffdad06b76c0cfab73ede972cb875740"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44592df67dc7cd9bdd5bc3df03c8de0fffdad06b76c0cfab73ede972cb875740"
    sha256 cellar: :any_skip_relocation, sonoma:        "7bcd509d08a60803be39aff7549e17a9c8f9e0850d92787d6b5e15f3388caa0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74107e8c05bfe9286461a934600e574de69c58cf882e76f5c2a864aea3ab67e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3933d0ff429fd9e214d61ddeae70c43c7637aaf8265a9890c5d5da25dda955f4"
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