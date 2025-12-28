class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.204.tgz"
  sha256 "a6d14f1637094f9f956a589ecd6d01a72a2e6e6411660c1d5a24a2cea7905eb3"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "78f8157bbaa0ad64e9e02670b2b3ec904f055207542cd1731fd14a1443c32655"
    sha256                               arm64_sequoia: "78f8157bbaa0ad64e9e02670b2b3ec904f055207542cd1731fd14a1443c32655"
    sha256                               arm64_sonoma:  "78f8157bbaa0ad64e9e02670b2b3ec904f055207542cd1731fd14a1443c32655"
    sha256 cellar: :any_skip_relocation, sonoma:        "510baeaf524a68f99e3a4327ebcb3f9e076f410261ee07a82e2cba632df6f870"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e5c0b11abbdb970d06f76a5c719635d781c68db722a6bd4f7d7146d119c5c3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b13071a41b536d5387f47888472ab0e6670b218e5744f8f1daac621be97b30e7"
  end

  depends_on "node"
  depends_on "ripgrep"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

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