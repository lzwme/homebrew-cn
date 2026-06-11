class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://github.com/MoonshotAI/kimi-code"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-0.13.0.tgz"
  sha256 "d89859c0c461b45a34de562c171202915dd8d8a4ed617d2fdac8f598b521be92"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "182062149d168e610725e6bd71a0c3cefbdfc7dbed06c41b8183a533c098d765"
    sha256 cellar: :any,                 arm64_sequoia: "6cbdbf26f38d1b197729737aca1fc8905563b05a1b2b5b513c68528cfc7074ab"
    sha256 cellar: :any,                 arm64_sonoma:  "6cbdbf26f38d1b197729737aca1fc8905563b05a1b2b5b513c68528cfc7074ab"
    sha256 cellar: :any,                 sonoma:        "f9f7bc1dd9a2a0b58428a6775000ed489cd936c85e72331dcbf2c41513383445"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6193d6b1dc9c5649524badcc899ab79684129026df7f22bc6b142fb63b9b4651"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02e25d4142e19606f42e278c94546ba7413eca0d7cc5a060364a73a52a591be4"
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