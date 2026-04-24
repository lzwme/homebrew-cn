class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.23.10.tgz"
  sha256 "5fb29fb3472fd190413caf7131928c4002e5ee59a2a3f51627bd503e65043f45"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5d4cbb372f466f75ff57cea07d46b4c3b367738fd7d448024d3137c200ec1043"
    sha256 cellar: :any,                 arm64_sequoia: "ebcd021d8a61d3863a906203698e96fe3f68297ec5dd69bc3efd7e7eced2477b"
    sha256 cellar: :any,                 arm64_sonoma:  "ebcd021d8a61d3863a906203698e96fe3f68297ec5dd69bc3efd7e7eced2477b"
    sha256 cellar: :any,                 sonoma:        "9996aa4d10107cb606b3c9ef6d5fcd5e001f9bfe60de404a7b66e309312a1a69"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d55a34a21f3b62d4b53348c8c18659f1066369b66fe8d097aea316eb110d51e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3553ff06589b4150d800bf65dcdd4a5780ce32c3b6396551daa0544db25efc1f"
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