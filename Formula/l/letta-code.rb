class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.23.4.tgz"
  sha256 "4b50cc84a15c26b1899c89f54f7aa9698bd4d6634c133f83c1e9c41135d61616"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "861b549019951871d5fd44c880ab1547583f3c7b3fd564dacbca3209a725bd7c"
    sha256 cellar: :any,                 arm64_sequoia: "f94d1d08ec0ea6767c8782afbd981da1ea2ccfdf93683af2c5868e0e287e0679"
    sha256 cellar: :any,                 arm64_sonoma:  "f94d1d08ec0ea6767c8782afbd981da1ea2ccfdf93683af2c5868e0e287e0679"
    sha256 cellar: :any,                 sonoma:        "eef64e655da567f68b3687a4105f668bb7caed472bc5726e3bdefd7b09ecb1cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4fbf6d55bf111ff7a71d1cb81541cc7943eb4c27de3eb657ff59ddcc7ff3d028"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c316e13f076d0b51ceba62d503056c65181ceb0f5c871f04647a30587b920c1"
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