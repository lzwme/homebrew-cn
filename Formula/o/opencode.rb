class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-0.15.13.tgz"
  sha256 "da5565a104c0c00d38f4fb160d2da1a0043f86c7864d9ad5d2d44cddae01b818"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "0dc973ac4d6ac38aec2e2d50eaa3e6c3f07f06869713e2e3481acc13ab4f0043"
    sha256                               arm64_sequoia: "0dc973ac4d6ac38aec2e2d50eaa3e6c3f07f06869713e2e3481acc13ab4f0043"
    sha256                               arm64_sonoma:  "0dc973ac4d6ac38aec2e2d50eaa3e6c3f07f06869713e2e3481acc13ab4f0043"
    sha256 cellar: :any_skip_relocation, sonoma:        "acc7370920d52155c5ae0510a19d0d77a8960d21fb374aced1bd11e1eb6eca01"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8faf1abab5a5fdbb1f2dc7b1da0415a6bad551f0209155298d87c3f5da927c61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f5ee873fd754db50fa136e12e454a8d0aa021c552ac4b89562ad740a3f6dda0"
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