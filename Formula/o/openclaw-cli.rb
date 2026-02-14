class OpenclawCli < Formula
  desc "Your own personal AI assistant"
  homepage "https://openclaw.ai/"
  url "https://registry.npmjs.org/openclaw/-/openclaw-2026.2.12.tgz"
  sha256 "0adafbffc20a4db8e6e4e1f51c6363fdf5a510b811dded7a752788740a31a8ba"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3104c650663a19695ccc4982daf248b6e48aec6ad47421cfdaf0856eba0074f6"
    sha256 cellar: :any,                 arm64_sequoia: "24758b4c5aca4def931c8dd46eda63cf4857044ec6f6621b85cb0f813cfe35ed"
    sha256 cellar: :any,                 arm64_sonoma:  "24758b4c5aca4def931c8dd46eda63cf4857044ec6f6621b85cb0f813cfe35ed"
    sha256 cellar: :any,                 sonoma:        "1d9c90d2e0264b6623fa5cb8ce0762510de48d6220cc225ab67e13efd0a2b747"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "046d7edb44c6fad650cfa4106a2d06aea2728e3b9ad92dd2f97eb60ab65fc296"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d7a50dd412933d4ac3268151548db7bfcf796757c66e023414d0c750c511f8b"
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