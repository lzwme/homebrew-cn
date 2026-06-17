class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-0.15.0.tgz"
  sha256 "ee634671c96eaa9913614cfbf057df0948e09f36aa165ebc067bafd2db81b697"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8a4ce791c5109938c37c72728f62a6d5ddc811963a5c45306eaf5e013ddbb4eb"
    sha256 cellar: :any,                 arm64_sequoia: "1acc4ffdf422e208d5f399ecf1047a2fd6000ae74254e087feef66e91f505bc3"
    sha256 cellar: :any,                 arm64_sonoma:  "1acc4ffdf422e208d5f399ecf1047a2fd6000ae74254e087feef66e91f505bc3"
    sha256 cellar: :any,                 sonoma:        "a89350e20128fcf802b170aac0c96f257797d9c8aa845fff6f65fc4ae26d974c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05df827644d0532b3ec27ccbbd0d9f4c330bdc5b9619f6aad33e61ae1a49fa46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b0faf749cd71dafaad7b56ea9f68efb0961608b0ecd090cd7be2447a69c6a20"
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