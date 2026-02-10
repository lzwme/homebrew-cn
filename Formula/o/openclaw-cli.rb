class OpenclawCli < Formula
  desc "Your own personal AI assistant"
  homepage "https://openclaw.ai/"
  url "https://registry.npmjs.org/openclaw/-/openclaw-2026.2.9.tgz"
  sha256 "0f7c67bd47dd2b84679ef35a741fabcea1f06daab7f5d98d6db0f9cbf45de80d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "91c224d3e131f22e99a15100576795def18ac08830e5ffe4d1fc205c9b61d2c9"
    sha256 cellar: :any,                 arm64_sequoia: "79f2e68579f5ab6520a69229728b56e859b96fcea10a5af52f8da1b2d4b7d203"
    sha256 cellar: :any,                 arm64_sonoma:  "79f2e68579f5ab6520a69229728b56e859b96fcea10a5af52f8da1b2d4b7d203"
    sha256 cellar: :any,                 sonoma:        "df68bb0bfa3b034829258fbc1c748b961bdd4dd3920d2c5060f19ca121c8db64"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1843aaaa436c4745920a50edf92baf3559c786d231b154edd5e2f6bb34754527"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92f74aba9ec2658dc1cd1e73cca3e3f43afb87e374581cdace7ce09284b5a2c2"
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