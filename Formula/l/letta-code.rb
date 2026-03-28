class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.21.1.tgz"
  sha256 "5e630a377a7e0e643b1c1b16cef26be002d06d33237575684f0c6062ac2dc9da"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b7626e4ed36aa05ab90e6e9f84e4f0000309e6bea57ae6403520011b03a8951e"
    sha256 cellar: :any,                 arm64_sequoia: "2201a631a9c4d45f28dcab2ea027eda2723fe439b0d7ecd996586546d5a07851"
    sha256 cellar: :any,                 arm64_sonoma:  "2201a631a9c4d45f28dcab2ea027eda2723fe439b0d7ecd996586546d5a07851"
    sha256 cellar: :any,                 sonoma:        "847aef5a8f5f692245bd97313f5f4f9c31a97e8e998aee777b5c75b176eab09d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ccd49ef8fb22a4e11ee6a40e02e88745bac525e20a851241ad7d2ab5056a6b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10e837868e63369f32f88657cee56ff43b6204061c7c3fad10f35a9d23ef0df8"
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