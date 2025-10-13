class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-0.15.0.tgz"
  sha256 "1f2084de8868d8a81a2f8e389818c643ff4639327fd057beb909fcc7864eff02"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "19f702d4a3db5cf20b056f0cc084382478ef4fc195f52928658a867b9422bac8"
    sha256                               arm64_sequoia: "19f702d4a3db5cf20b056f0cc084382478ef4fc195f52928658a867b9422bac8"
    sha256                               arm64_sonoma:  "19f702d4a3db5cf20b056f0cc084382478ef4fc195f52928658a867b9422bac8"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3cf528bec53c2238504f302f7d447e5d1a28e570c3d21d80418ca8e07eb74c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ef44f65dc83e12a95178daf66006357f3c8532b95e28360afaa212be2149b11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b04935ce97de490b9fa08927691cb926787fdc0bc63c65f32ca43df5ff7db24b"
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