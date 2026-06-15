class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://github.com/MoonshotAI/kimi-code"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-0.14.3.tgz"
  sha256 "78c9328c7013df6b0867b44c25927963c447044f3fe91ae0140d9446b6741504"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "060ef299412f6b97d42329fc48077d2e8cd272e844d7b02b3572433f7c86f387"
    sha256 cellar: :any,                 arm64_sequoia: "3e526cf0d77d5525a6348964bc4f1b31f87a5b75f8ec1dcc7b30e152e6a383cd"
    sha256 cellar: :any,                 arm64_sonoma:  "3e526cf0d77d5525a6348964bc4f1b31f87a5b75f8ec1dcc7b30e152e6a383cd"
    sha256 cellar: :any,                 sonoma:        "e97fe057af9bc73e1e372aea7ef79e359df495392c15aaab67638539831eb3c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c1ee523ccffcc4cce2f538139ac03ad56df5b332759ae9b25c67e8c7a3127c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c179ea350e2031ad6a1d5bf8aa1f40cf749305a3d316a37b9f4ba33d70421c6"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir[libexec/"bin/*"]

    node_modules = libexec/"lib/node_modules/@moonshot-ai/kimi-code/node_modules"

    # Remove non-native architecture binaries from `koffi`
    if OS.mac?
      if Hardware::CPU.arm?
        rm_r node_modules/"koffi/build/koffi/darwin_x64"
      elsif Hardware::CPU.intel?
        rm_r node_modules/"koffi/build/koffi/darwin_arm64"
      end
    elsif OS.linux?
      # koffi requires libc++ which is not available in Homebrew Linux;
      # remove all prebuilt native binaries to avoid audit/linkage failures
      rm_r node_modules/"koffi/build"
    end

    # Strip universal binary to native architecture for `clipboard`
    if OS.mac?
      deuniversalize_machos "#{node_modules}/@mariozechner/clipboard-darwin-universal/clipboard.darwin-universal.node"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kimi --version")
    assert_match "No providers configured", shell_output("#{bin}/kimi provider list")
    assert_match "No model configured", shell_output("#{bin}/kimi --prompt hello 2>&1", 1)
  end
end