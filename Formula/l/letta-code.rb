class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.24.5.tgz"
  sha256 "5f5777b5c1234c058d228a553374c6265a2abf0689c4ef914d140b97858ab0f0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1b69f7dd47fb04f3a43f8fedc4ecb9e09ba6ba64153a32fbebb9259a430c9ee4"
    sha256 cellar: :any,                 arm64_sequoia: "8ef709698d9364d575b54771b9124009ff1b42071f0311f0cd6ea1006dbd5d8a"
    sha256 cellar: :any,                 arm64_sonoma:  "8ef709698d9364d575b54771b9124009ff1b42071f0311f0cd6ea1006dbd5d8a"
    sha256 cellar: :any,                 sonoma:        "77db094ea95070ff619b1c408b7961cfb2cc0fce22cb71e34ac20e6201e8bce8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4af9520d657d4a378fa0b38c9a4cf3e9e6da2c612bd3acc1e318ff6c45e541e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52bfbb153c6538178b2ee6c9adeff61cf1112e1d008d4b687cf0d326d29c4500"
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