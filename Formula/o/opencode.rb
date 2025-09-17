class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-0.9.6.tgz"
  sha256 "817b36876aa8edb9238f736bfd3700cbd8a5879429b7dd9d17e7131d65e34c3f"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "b1ce6d2dc7ac3f1ba1a8675833d7f6a3355d364051e3c560194a06cb814ca247"
    sha256                               arm64_sequoia: "b1ce6d2dc7ac3f1ba1a8675833d7f6a3355d364051e3c560194a06cb814ca247"
    sha256                               arm64_sonoma:  "b1ce6d2dc7ac3f1ba1a8675833d7f6a3355d364051e3c560194a06cb814ca247"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d8d6706dffcd46f4627887f10d86cc134cde62221ae80f928a06fd0464865f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "437bc0f236ebef544c994986f86e1a96184ab36150547f185fd3feab41ccb54a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opencode --version")
    assert_match "opencode", shell_output("#{bin}/opencode models")
  end
end