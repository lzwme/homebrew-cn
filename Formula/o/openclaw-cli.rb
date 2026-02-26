class OpenclawCli < Formula
  desc "Your own personal AI assistant"
  homepage "https://openclaw.ai/"
  url "https://registry.npmjs.org/openclaw/-/openclaw-2026.2.24.tgz"
  sha256 "0f31d79c8ca77a5af9758834067e51bb8c9ce4e513c60b839ef577db66d1aff2"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "599bb81c8a975645cbe95442762cef23f78b26a6c864225b423d947db7ffef89"
    sha256 cellar: :any,                 arm64_sequoia: "4fbb1ec5e62771417c025a1a427f0ba60e5e3d02fd7138fe9446ad2cfe3305a2"
    sha256 cellar: :any,                 arm64_sonoma:  "4fbb1ec5e62771417c025a1a427f0ba60e5e3d02fd7138fe9446ad2cfe3305a2"
    sha256 cellar: :any,                 sonoma:        "47ff9315cb8a964277df47cfa464abe7e37b0a92265ca1bae38885c11318be59"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "779216615bd82d41b754c00fdc2ba39bfd455a7f68394e1ba183b0aea78d5fad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b6f76a6cb3735f2365bcd32cde19a515d1753b472551d4f3a49854ea3151b9a"
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