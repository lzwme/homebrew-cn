class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.19.8.tgz"
  sha256 "42deb0b388c889f419c8e43589dbcbcf5d8720b9be05206008f6b3ae15519eac"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "96d91f6757e78a76853c8d07c6158ddbf21a9e086988569182fae3a89f9b137d"
    sha256 cellar: :any,                 arm64_sequoia: "8f99f2d012c7b267699da22b119773a88b79206d563e0449f018a5f5932da71f"
    sha256 cellar: :any,                 arm64_sonoma:  "8f99f2d012c7b267699da22b119773a88b79206d563e0449f018a5f5932da71f"
    sha256 cellar: :any,                 sonoma:        "6c3aef32819010a758385b89d3226496dc51adfd79c9cc842a9b26337f4f03c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "73e1b8349ba7bc1e00c27c7e90416854ba1d91e007b779391c9f9c08cfa23707"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec026039a238c5615d7cecbb8818f6bcdb14971c36cd938f7a1bbdd5d9ecf1bb"
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