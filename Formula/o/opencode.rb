class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-0.10.0.tgz"
  sha256 "88580df7df1c9fb5b8556ba18cd3fc3e970870413bedf1a2030130d4c43cb387"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "4fb7c2470a56263d924a0d3fe895e699b5b3c4d32d1c4e4f881d16ead43977ee"
    sha256                               arm64_sequoia: "4fb7c2470a56263d924a0d3fe895e699b5b3c4d32d1c4e4f881d16ead43977ee"
    sha256                               arm64_sonoma:  "4fb7c2470a56263d924a0d3fe895e699b5b3c4d32d1c4e4f881d16ead43977ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "d15a0c6edee0d643209d5f72abc500aff4054f127de4f34e57614a340341c155"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2952a915eced424072d7893d4c9a8a481fd03db69eedc7bc336ff84abe37f11d"
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