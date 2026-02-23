class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.16.3.tgz"
  sha256 "12fc60eed05337b06075b37ca295458ea10206bd0f8a8359ecb473bbda408009"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fecf51931190a9bf2c5919cc6951114609f9a4a5ed86e454c3474b2043b18792"
    sha256 cellar: :any,                 arm64_sequoia: "bb10a8ee4b543b774a6723f91d23585c54b66f90180b889fc8b0408c7747bc6f"
    sha256 cellar: :any,                 arm64_sonoma:  "bb10a8ee4b543b774a6723f91d23585c54b66f90180b889fc8b0408c7747bc6f"
    sha256 cellar: :any,                 sonoma:        "0e0149415be715a3b82c5e72010c5b8672a6b319b59a6d9b974aa81a584ffd65"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "612e875b13baaae3610e355c55bad1603d3ea551b2471760ed8f6dbe02aaec57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b019faaaebe25f7bf57bd02d8a1aad6df5fd3215b1e3d3e352d69731a074b2d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/letta --version")

    output = shell_output("#{bin}/letta --info")
    assert_match "Locally pinned agents: (none)", output
  end
end