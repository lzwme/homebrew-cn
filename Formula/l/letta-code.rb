class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.19.10.tgz"
  sha256 "09d9171a6d930562a0b2eafb3bfbe5dab08bc4999361accd8d0f73c351db85c5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5d5c91e5b2ac952541de8dbaa9af8d14c963cc25685974fbadaa8e81d4cbeb1e"
    sha256 cellar: :any,                 arm64_sequoia: "8dbe7847067db785371032daeb53a69b63bbe34fe4307cfd7ceaa7ae6efdc82e"
    sha256 cellar: :any,                 arm64_sonoma:  "8dbe7847067db785371032daeb53a69b63bbe34fe4307cfd7ceaa7ae6efdc82e"
    sha256 cellar: :any,                 sonoma:        "8acfb7822c1cafdd22a2ad6a1169cf96ddad3bfcb14919a959413a852562e07e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4c48a053abe16a86b31fc95739f26675bbe366eaf2a9fd880f24496357568b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "336aa48b1d7222b6a42a2f25c46f004ac6f6f59896adb4822bded469688230e4"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/@letta-ai/letta-code/node_modules"
    (node_modules/"node-pty/prebuilds").glob("*").each do |dir|
      rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/letta --version")

    output = shell_output("#{bin}/letta --info")
    assert_match "Locally pinned agents: (none)", output
  end
end