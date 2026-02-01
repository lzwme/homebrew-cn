class OpenclawCli < Formula
  desc "Your own personal AI assistant"
  homepage "https://openclaw.ai/"
  url "https://registry.npmjs.org/openclaw/-/openclaw-2026.1.30.tgz"
  sha256 "01225c50375ed369613da55c33f27fcaf25aced98e16b76a1560dfe49cc47b86"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e96119d232b9fc446c84edc978981574306fa607859fcc547652fde83b992462"
    sha256 cellar: :any,                 arm64_sequoia: "4fda3d7b6780870255b889265add1ef166878b6d91e4fe9771ecf2ae720b851e"
    sha256 cellar: :any,                 arm64_sonoma:  "4fda3d7b6780870255b889265add1ef166878b6d91e4fe9771ecf2ae720b851e"
    sha256 cellar: :any,                 sonoma:        "0d5b0ac061c8e00b469aba7d6f58bb26c3ab6ad9faa66ef6b8cbc8f409ca665c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9de11b36ffe4d919111e70332359ea772f8b15c6e8dda26de66fb25feb42539d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "edec007d51054891911d59d680f03f4a18f86f5c477e35276269ce88bb9e2a19"
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