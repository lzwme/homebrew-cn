class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.153.tgz"
  sha256 "0c88f6622076797d68ea121103908e8ffd74aaf6d07a6dad0c1dbce5d55c1f51"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "5abb894a8f6fd0d6d9b62fe000fbe3510d6be1b1dee611529ea67aa984cefe29"
    sha256                               arm64_sequoia: "5abb894a8f6fd0d6d9b62fe000fbe3510d6be1b1dee611529ea67aa984cefe29"
    sha256                               arm64_sonoma:  "5abb894a8f6fd0d6d9b62fe000fbe3510d6be1b1dee611529ea67aa984cefe29"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c8e20093c1280be2e3e935d62e985cc089f60024380b691a8f4a360db6e296e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a067524116ffe6b4478170ef5bba30bac5a57c1a759e8df65b26bb0b568c2bc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af00f77721e850737befc461b8dba5f1876f6d11312f62b437f53461c2c9999e"
  end

  depends_on "node"
  depends_on "ripgrep"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove binaries for other architectures, `-musl`, `-baseline`, and `-baseline-musl`
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    os = OS.linux? ? "linux" : "darwin"
    (libexec/"lib/node_modules/opencode-ai/node_modules").children.each do |d|
      next unless d.directory?

      rm_r d if d.basename.to_s != "opencode-#{os}-#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opencode --version")
    assert_match "opencode", shell_output("#{bin}/opencode models")
  end
end