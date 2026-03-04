class OpenclawCli < Formula
  desc "Your own personal AI assistant"
  homepage "https://openclaw.ai/"
  url "https://registry.npmjs.org/openclaw/-/openclaw-2026.3.2.tgz"
  sha256 "3ec99c93003725c3afb3d8c3236f7fb7054647d151dc27b9e0256e00372f31b7"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a08c1a15f6de287a35db391d4934ccce0375a9d2a4f2d6a41bacd7e514533e8f"
    sha256 cellar: :any,                 arm64_sequoia: "2872917fda9e852e3445499cd99773e5df3f07ff3cc860cdbb03b5fbd4924524"
    sha256 cellar: :any,                 arm64_sonoma:  "2872917fda9e852e3445499cd99773e5df3f07ff3cc860cdbb03b5fbd4924524"
    sha256 cellar: :any,                 sonoma:        "a2806fdb44e91c67e1bdffff3baf2c7915851f679c95311caf477ab007277297"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e68d4735bb51bc52628d42ec857c717cb4036e998d812b7bcc089a398ee52dfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76bf92d26f6aba79e65d8cba27ea8547e8fd49f745d2f41a18b4f1922b04773a"
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