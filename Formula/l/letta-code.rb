class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.23.11.tgz"
  sha256 "cf72cad04c800f72a9539c432b800ded6d618940b8845d1703275f9d0ab3b7cc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "441ec4e71d4dcf260353003814570e5f3740be59c533b48fcdbd71a933524fd3"
    sha256 cellar: :any,                 arm64_sequoia: "ba9e5b52f9f239fda34bbb21b2cfef6f26c8add5f50915ce4966bb0b6ffe35ed"
    sha256 cellar: :any,                 arm64_sonoma:  "ba9e5b52f9f239fda34bbb21b2cfef6f26c8add5f50915ce4966bb0b6ffe35ed"
    sha256 cellar: :any,                 sonoma:        "09f0bd476f8e210565fedb203ebc7b8220b0cee5a701bf68bda17efe48fe928b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41b8e6c111164340961bd69abbd3d62693f3d2b1ed3de7d4d6dba0e68165458e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b86ee2a067c5ed6af9acde9db0f09e458499c8a613b4319be2866b943bc60f5"
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