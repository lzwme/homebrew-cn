class OpenclawCli < Formula
  desc "Your own personal AI assistant"
  homepage "https://openclaw.ai/"
  url "https://registry.npmjs.org/openclaw/-/openclaw-2026.2.23.tgz"
  sha256 "26053f73fcd87f87e7bbd1562a835f3b6ae4a0205b931b8455ae0ecc5a59369e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b3103e9ca1067159ec767c04608787a397f4539e08aa32e796b2bc51555c7fcb"
    sha256 cellar: :any,                 arm64_sequoia: "162d77b6a3a355389e71b65dfa90b71afdd76fa96eba86ad69ca1776e899457a"
    sha256 cellar: :any,                 arm64_sonoma:  "162d77b6a3a355389e71b65dfa90b71afdd76fa96eba86ad69ca1776e899457a"
    sha256 cellar: :any,                 sonoma:        "e707c2a7130f59d0ddf19183c7de166c2c49b3604e53010b3a5b77f1da047645"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4688e9928494b4243c8fb3e181538111bc3f219d24b8d8254cf6373b11f4907a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8fb59de9e2bbef42a03f219da715e7a0b2614e35b8d4e58f7c386eeebe11bb1"
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

    os = OS.linux? ? "linux" : "darwin"
    node_modules.glob("koffi/build/koffi/*").each do |dir|
      basename = dir.basename.to_s
      rm_r(dir) if basename != "#{os}_#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/openclaw --version")

    output = shell_output("#{bin}/openclaw status")
    assert_match "OpenClaw status", output
  end
end