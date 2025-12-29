class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.206.tgz"
  sha256 "f97b1e3000a4046b2cb44ce2a7a990ddb84198e2f248998af261191cc7c7f047"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "2ef54d67918cbb763f7ce1d1c6ee66bc8c509829d78dffa278cd8f9302ddf2de"
    sha256                               arm64_sequoia: "2ef54d67918cbb763f7ce1d1c6ee66bc8c509829d78dffa278cd8f9302ddf2de"
    sha256                               arm64_sonoma:  "2ef54d67918cbb763f7ce1d1c6ee66bc8c509829d78dffa278cd8f9302ddf2de"
    sha256 cellar: :any_skip_relocation, sonoma:        "c72c2eb9d5c0b36ca2ad22a8058265d72ba05074b9a956e14ba51bf8fe72002b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b692ce709a962580a26e60c1dc39a9192e6c3fe4512cffb31fd77e903a0ab333"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4aa4962525e43e13a078946e0142ca39f31e16df7b73c26fcf39d7f6d6b89015"
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