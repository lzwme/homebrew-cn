class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.25.10.tgz"
  sha256 "511fbcc0efc7831883e41b80275b3ed648f0dfa6df127e87a94097dd38b70939"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bea429c3d0e66558dcb70af93aa3ff83dd872cbc2846352718c66b7f5a958767"
    sha256 cellar: :any,                 arm64_sequoia: "5ddb06422726841ae02726fa795f912233e46b2af56d4df4329549e01c9c5781"
    sha256 cellar: :any,                 arm64_sonoma:  "5ddb06422726841ae02726fa795f912233e46b2af56d4df4329549e01c9c5781"
    sha256 cellar: :any,                 sonoma:        "7b7b361e286524b9ed68c30d9523483d3bfd31de3a4581cf53b83b6c9be492e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7f56a1349b47d63fd6d76da96865fc74cc628688d8ad48f793060cc23cdd22a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8600d907861b15be80a02d9b617922d5cf77e5267433aa57d15b8d92b0ee1ad9"
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