class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.193.tgz"
  sha256 "12ca9a0907a9e3abb17caf8ae0b324ef1930e4268b514848804c47228bd3517a"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "5c3f7c573aa86ec25d5c3e71a06881a70fec7b577a534d42031a0b6e399048a4"
    sha256                               arm64_sequoia: "5c3f7c573aa86ec25d5c3e71a06881a70fec7b577a534d42031a0b6e399048a4"
    sha256                               arm64_sonoma:  "5c3f7c573aa86ec25d5c3e71a06881a70fec7b577a534d42031a0b6e399048a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef3420dc004bb643b94249a9ea3bfee1827395d978dbd510894a166d778f6b00"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1aa5017f7044a0dd4d75ec410c3728aaddb713bf1c7cc226961c83bb184c193"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0cda0ee52dde6c25959f2bf0e67064390b182109a13db2ee6d7396272b1f9c7"
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