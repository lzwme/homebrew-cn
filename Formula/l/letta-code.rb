class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.25.5.tgz"
  sha256 "feb90a87297457608b7d37b3135ea8e1e4a28718c365ceda5251eed7e97d51fd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2cb29ce7c0aa0cafff1252845847fee0e5231c3d42135f24602f18d13035b70d"
    sha256 cellar: :any,                 arm64_sequoia: "fa70ae74eb9bd43c3ed57d8600b5647a75871103e9361447e3d4fd39e49f165f"
    sha256 cellar: :any,                 arm64_sonoma:  "fa70ae74eb9bd43c3ed57d8600b5647a75871103e9361447e3d4fd39e49f165f"
    sha256 cellar: :any,                 sonoma:        "8d8ebe39be0ec1f5d105acbd9a911e1d58cf1ed5727d6b1e5577de42166eab57"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b7fc9ad195ba6a19c083163f29c75257f9efaddf28ae1527ab12f6526a5e52f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5778e384c2a66fa84e01f8e5620beaa075cea140e294c78d83361d7b0dd6b85f"
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