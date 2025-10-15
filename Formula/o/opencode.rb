class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-0.15.3.tgz"
  sha256 "48cb3c552dba17e5c46338d7ea0bc39246d4d5a48e92f0ee376db89cd6f28c12"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "9e57781e8a6d96c0e1e045a80c85806a56501fc5359c70b47b49b205af7396e5"
    sha256                               arm64_sequoia: "9e57781e8a6d96c0e1e045a80c85806a56501fc5359c70b47b49b205af7396e5"
    sha256                               arm64_sonoma:  "9e57781e8a6d96c0e1e045a80c85806a56501fc5359c70b47b49b205af7396e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "a76efc31b3a181207821bcfbffa25d78ff1cc769c224f9f12bc3555a5cf2ac15"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "951e00d3cae89aa47a6efbd736b5deb97c92ca9315c109892d46d7d8dbc11efb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1487bf6a9b47a56e78a9c094bc3a250de3c2d2eefae245537ba6461c87b1434"
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