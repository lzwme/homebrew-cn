class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-0.15.18.tgz"
  sha256 "b63d57e068ba9b656263eb14a95f8458abb56d46a387d251669ad01008113fd3"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "15c68d7f770c8095a662f3c2560073124c3e442bee8d233fa58caf96300b99d6"
    sha256                               arm64_sequoia: "15c68d7f770c8095a662f3c2560073124c3e442bee8d233fa58caf96300b99d6"
    sha256                               arm64_sonoma:  "15c68d7f770c8095a662f3c2560073124c3e442bee8d233fa58caf96300b99d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "2132078688a4b9f74da15546b47712c5d8d8d0fe667144c300da3a869bfa0ecb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dbc5083d889f4208cdc14414259c6091c6914aa2f593ca70a5abb83f01aa0f34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da5e6cec6b22f5b25e68684423a1e614ced64c11126917f43bf5448775cdbdc0"
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