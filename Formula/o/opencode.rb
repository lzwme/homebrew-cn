class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.1.30.tgz"
  sha256 "ef331a76bdcd677ff4214ddc1c0b9725d6bd1e785c35fcd46a7becee553ab521"
  license "MIT"

  livecheck do
    throttle 10
  end

  bottle do
    sha256                               arm64_tahoe:   "d6d7a4102450e620407900843fbbed85dba0e1a7623e44640bf4a84db6534aae"
    sha256                               arm64_sequoia: "d6d7a4102450e620407900843fbbed85dba0e1a7623e44640bf4a84db6534aae"
    sha256                               arm64_sonoma:  "d6d7a4102450e620407900843fbbed85dba0e1a7623e44640bf4a84db6534aae"
    sha256 cellar: :any_skip_relocation, sonoma:        "519e65a2003231d6664f29647f05bb1cffb067116cd1d151fdf2f3188730d16d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c75cde5d6b6dee7d78a830836fbdd5a765876686d4f304137b293e02a5c3f48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92eb1177d2c2b2550640d2de78a5011fd8b8be361fb1f35e683de4691a0b689b"
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