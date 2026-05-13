class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.25.7.tgz"
  sha256 "71f02a1e47855b8a8292808d021fcc353d29131da5d262a87c9795b21a96e69f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "da166acc7f9b540cf9331fc42a1c9e38901247f528fc02127d8e5ea38c803e91"
    sha256 cellar: :any,                 arm64_sequoia: "32434c55a6e348da2167a77c1ebbc766c5ac17aac0537c3365ed2ee914372fc9"
    sha256 cellar: :any,                 arm64_sonoma:  "32434c55a6e348da2167a77c1ebbc766c5ac17aac0537c3365ed2ee914372fc9"
    sha256 cellar: :any,                 sonoma:        "3c28003ebba02f5d1429b76a13408de1e4eb0d29b3c2506cccd0b65df76fa089"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "efe9d08aa3a189e2429e10e5e67c7a670d456b413fb0906e94ad05936e89bab9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef0ee844bfd81b9c813a8e1de838ffdb962065e92f0c57e7b28e2acb11f5f1c2"
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