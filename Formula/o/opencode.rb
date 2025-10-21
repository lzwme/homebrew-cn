class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-0.15.10.tgz"
  sha256 "f651f65e049e05cd3fff577c379c25b042dd51160ac5064a285dec317cd233ad"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "3bf39fe2af81f5cfb3d3b05558a47eb50442fe6e58f7f9fe778c1729c8c3da17"
    sha256                               arm64_sequoia: "3bf39fe2af81f5cfb3d3b05558a47eb50442fe6e58f7f9fe778c1729c8c3da17"
    sha256                               arm64_sonoma:  "3bf39fe2af81f5cfb3d3b05558a47eb50442fe6e58f7f9fe778c1729c8c3da17"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2731b8d12a597cda7d07b10b726d9bd48e9577bb561f76f921c5688efc24459"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81ea65a7613c57bfc1122f409620dc812ad090319f3f932c3d1c75e6e207ed69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1210f562931bb737f94d09cf08709e6187b7f88bebef80d5907b1605fa55e577"
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