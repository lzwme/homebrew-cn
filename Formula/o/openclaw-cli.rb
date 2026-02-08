class OpenclawCli < Formula
  desc "Your own personal AI assistant"
  homepage "https://openclaw.ai/"
  url "https://registry.npmjs.org/openclaw/-/openclaw-2026.2.6-3.tgz"
  sha256 "cc33111738dd7ad770d10e3bbaa088287a2a57b5308f12a74ba2fdbb65684c93"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f5b70c700e1a1ab4ad35372b6ff08a429bf697f21b1d39cb80d2ef3ef1f8b00a"
    sha256 cellar: :any,                 arm64_sequoia: "318e4cf176135242714d7348f44cea3962a13372a6592cac23ad840d20d0e3e6"
    sha256 cellar: :any,                 arm64_sonoma:  "318e4cf176135242714d7348f44cea3962a13372a6592cac23ad840d20d0e3e6"
    sha256 cellar: :any,                 sonoma:        "0ae614a75aca70b582ead321e636bf89b81eb1bb7c883ba1b5ce146ef7e87915"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8763796fd9daa070bac148dda6ee0276da19b97630878270a46c6be02a5bcc88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5c0a6335559d6085cf3c5921df6b00d96d3da07142f56ca1dcd75f2b10b40aa"
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