class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.203.tgz"
  sha256 "b65c161d9321e787b55bcdcb9d5d7b1c7f9305bd86964464864648f35daafa3c"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "130fb5f50406a98b4b7d85f1c280b6154a961db058d8c10c6160a434aa5176d4"
    sha256                               arm64_sequoia: "130fb5f50406a98b4b7d85f1c280b6154a961db058d8c10c6160a434aa5176d4"
    sha256                               arm64_sonoma:  "130fb5f50406a98b4b7d85f1c280b6154a961db058d8c10c6160a434aa5176d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "7bbcdb0e29d7c6a5aaa74dfb88c6e4b644efc44602c63b2fb42a5021b47bf823"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5ba3ab2ebf3575cf4da9cf697af3b26fc5c282fcf1bbf0773aa0fa806b3c5a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea4b85979acfe993a60c0035cb0487d588be1c2c9f20839b69ae99d64cf02703"
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