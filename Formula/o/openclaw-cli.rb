class OpenclawCli < Formula
  desc "Your own personal AI assistant"
  homepage "https://openclaw.ai/"
  url "https://registry.npmjs.org/openclaw/-/openclaw-2026.2.25.tgz"
  sha256 "9012376acf5a95daba7e86485453bffc623b42927d7c878ab367a73236b3f8b4"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "21eebb61dbf4d5e0a606742e68fa8d1789ad15a22cea9dc966424f13f33b64f2"
    sha256 cellar: :any,                 arm64_sequoia: "eb280f5cb021d8c06f23b5ceede0e34b1f7f6a829737b6319972cb8ee3f6aa00"
    sha256 cellar: :any,                 arm64_sonoma:  "eb280f5cb021d8c06f23b5ceede0e34b1f7f6a829737b6319972cb8ee3f6aa00"
    sha256 cellar: :any,                 sonoma:        "15c41d76e0194f96095d68e53b64cea7d2fcdace12e9dcb5c44b82c1929405b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25752361d90b54f93191d7136ceb6f3c43b054be5689ca6168e4dc5e309f46cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6294432c2b0d71af1c26ce7840b1ea6eb6e2437e0f148db4e5615d9d0cf5dc67"
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