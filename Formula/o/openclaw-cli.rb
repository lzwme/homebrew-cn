class OpenclawCli < Formula
  desc "Your own personal AI assistant"
  homepage "https://openclaw.ai/"
  url "https://registry.npmjs.org/openclaw/-/openclaw-2026.2.3-1.tgz"
  sha256 "c149cb63e1bee395c6d52c8dd377d9fd398a25434e584b95409eb4c09afcefc6"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "50dd35826e08693c13df7f7405650d579fe5d6b9628f0b4ef1b0eb5b52c66ef8"
    sha256 cellar: :any,                 arm64_sequoia: "53c8404ba6faef0c0a907f1065480687f84baf28ed1225f728820d41de168518"
    sha256 cellar: :any,                 arm64_sonoma:  "53c8404ba6faef0c0a907f1065480687f84baf28ed1225f728820d41de168518"
    sha256 cellar: :any,                 sonoma:        "3261603fe2e8569a9a818c22d19b8808ad2ed6d3439cbef759521c11ad746a3a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ae1eaa972c81ffe9561906485e72c75cbf08ee515f441d2f8b102ca4292ccae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56a94c0050d416a933de6059b81d54e11f6a9c8f78420a405f8734ecd3a04da6"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/openclaw/node_modules/"
    deuniversalize_machos node_modules/"@mariozechner/clipboard-darwin-universal/clipboard.darwin-universal.node"

    # Remove incompatible pre-built @node-llama-cpp binaries (non-native
    # architectures and GPU variants requiring CUDA/Vulkan)
    os = OS.linux? ? "linux" : "mac"
    arch = Hardware::CPU.arm? ? "arm64" : "x64"

    node_modules.glob("@node-llama-cpp/*").each do |dir|
      basename = dir.basename.to_s
      next if basename.start_with?("#{os}-#{arch}") &&
              basename.exclude?("cuda") &&
              basename.exclude?("vulkan")

      rm_r(dir)
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/openclaw --version")

    output = shell_output("#{bin}/openclaw status")
    assert_match "OpenClaw status", output
  end
end