class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.17.5.tgz"
  sha256 "05165ae40c9b222db275c8482300c948e881a6767aed2e67056223f43069f99c"
  license "MIT"

  livecheck do
    throttle 5
  end

  bottle do
    rebuild 1
    sha256                               arm64_tahoe:   "ca653eb8c0a682d6d18fccfdeff1294768df49a617a3d7c799948fe4d4f1467a"
    sha256                               arm64_sequoia: "ca653eb8c0a682d6d18fccfdeff1294768df49a617a3d7c799948fe4d4f1467a"
    sha256                               arm64_sonoma:  "ca653eb8c0a682d6d18fccfdeff1294768df49a617a3d7c799948fe4d4f1467a"
    sha256 cellar: :any_skip_relocation, sonoma:        "18f5988198e1c8804fb1f14358b59c9ae87a39940613a4dc7d6021266882ca26"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "984002edcfa2b6cd6e1a9aac60fa633c405ba7c84eb4db30177a69a6dabfd09b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b94552644a7fa937b46efbdc86707969caa898a8131aa79561d8412ccc806da"
  end

  depends_on "node"
  depends_on "ripgrep"

  def install
    system "npm", "install", *std_npm_args(ignore_scripts: false)
    bin.install_symlink libexec.glob("bin/*")

    # Remove binaries for other architectures, `-musl`, `-baseline`, and `-baseline-musl`
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    os = OS.linux? ? "linux" : "darwin"
    (libexec/"lib/node_modules/opencode-ai/node_modules").children.each do |d|
      next unless d.directory?

      rm_r d if d.basename.to_s != "opencode-#{os}-#{arch}"
    end

    generate_completions_from_executable(bin/"opencode", "completion", shell_parameter_format: :none, shells: [:zsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opencode --version")
    assert_match "opencode", shell_output("#{bin}/opencode models")
  end
end