class OpenclawCli < Formula
  desc "Your own personal AI assistant"
  homepage "https://openclaw.ai/"
  url "https://registry.npmjs.org/openclaw/-/openclaw-2026.2.1.tgz"
  sha256 "eb737fb5ea4f771ed11b3870ff0e72fc978b723f944382fd16c7844b8d69ea03"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "88a38403c4a742a0c53752126581b86802c307a8df12c51359cf73fd66ce3e2b"
    sha256 cellar: :any,                 arm64_sequoia: "360851c232d646d78f1d8c9f2df54a663d428a6b4d5bc72f686697c84082fc87"
    sha256 cellar: :any,                 arm64_sonoma:  "360851c232d646d78f1d8c9f2df54a663d428a6b4d5bc72f686697c84082fc87"
    sha256 cellar: :any,                 sonoma:        "5ff72892d6fc40881f326378ba1543521bfc86c51e5358845fc9704cf556fed1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ca51cf1ad3f0ea368471d8684d912bd4fc4aec36c60bd490ea278f9af1604ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e98e4fef360d82d468cba236e845e37e6570681d27b2e36498f1707321ba479"
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