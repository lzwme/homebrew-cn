class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.189.tgz"
  sha256 "de1c7b1d61bb1abbb5008c022ceb20fd38a8d60a9307d585182fd7685754a2d2"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "1cd4d9d97df46d8d64718258f684d05ca7fec8311b25a522f3f0ad8f3c627621"
    sha256                               arm64_sequoia: "1cd4d9d97df46d8d64718258f684d05ca7fec8311b25a522f3f0ad8f3c627621"
    sha256                               arm64_sonoma:  "1cd4d9d97df46d8d64718258f684d05ca7fec8311b25a522f3f0ad8f3c627621"
    sha256 cellar: :any_skip_relocation, sonoma:        "382aff8fc16e8a6aa30c6ea0165254f382e2e2466130f430c495b244fd8fa91e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2083e3ddad89ba612cfca6860d2fbdf88321b2eb1da8a3c3c88fb9a7163b2fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd4a835c0a7cd564c835e203275e598909888914a39419557bd11bbe7001f7ad"
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