class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.19.2.tgz"
  sha256 "28ebfc5ceb2774fcb250a9d9f9cdd63048b3154dabf3f9c00760d114a2bb8b61"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a23808d33a0792c8008ab615c1158590638c90b32396d9e3aedc2238cd70facf"
    sha256 cellar: :any,                 arm64_sequoia: "dfd845d2006b62a43c3e351ef888a17b13a17d48c011c8d344dd0924b517bc1e"
    sha256 cellar: :any,                 arm64_sonoma:  "dfd845d2006b62a43c3e351ef888a17b13a17d48c011c8d344dd0924b517bc1e"
    sha256 cellar: :any,                 sonoma:        "0a77e93145e200e323cd6d12ffc5519740aae17e055bc69820bb3aaac8a14fbb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "282383912dd2ad1822905101951ddd32b817d67def6b77c29894ab8158508840"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "532007f7189d96dd1505b44737c4975f170d9282a41c5299558d31ee71bb655b"
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