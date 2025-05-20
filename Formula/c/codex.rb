class Codex < Formula
  desc "OpenAI's coding agent that runs in your terminal"
  homepage "https:github.comopenaicodex"
  url "https:registry.npmjs.org@openaicodex-codex-0.1.2505191453.tgz"
  sha256 "0d6c99701fe55ae126b76330c7b536a14907799683791493e5496afe6eb142b2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a51b6ccd85e654bb9c942cf44004d6f53bf71ff7e2569b5194a01f1f76db75f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a51b6ccd85e654bb9c942cf44004d6f53bf71ff7e2569b5194a01f1f76db75f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9a51b6ccd85e654bb9c942cf44004d6f53bf71ff7e2569b5194a01f1f76db75f"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d538efeb8b6b2c659976b6dfdb78476a8778f32ee5d8c9525b8dcbe49e27792"
    sha256 cellar: :any_skip_relocation, ventura:       "9d538efeb8b6b2c659976b6dfdb78476a8778f32ee5d8c9525b8dcbe49e27792"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a51b6ccd85e654bb9c942cf44004d6f53bf71ff7e2569b5194a01f1f76db75f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a51b6ccd85e654bb9c942cf44004d6f53bf71ff7e2569b5194a01f1f76db75f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]

    # Remove incompatible pre-built binaries
    libexec.glob("libnode_modules@openaicodexbin*")
           .each { |f| rm_r(f) if f.extname != ".js" }

    generate_completions_from_executable(bin"codex", "completion")
  end

  test do
    # codex is a TUI application
    assert_match version.to_s, shell_output("#{bin}codex --version")
  end
end