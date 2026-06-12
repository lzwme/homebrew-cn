class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://github.com/MoonshotAI/kimi-code"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-0.14.0.tgz"
  sha256 "2e887f8f7b1203e6cb554452044371d0f5f7af8e3ab1653f2c23d62b2f560e2b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "db875a55a3dcdc3fa884fa150e16ef4e51ef34ea65a393bdfb3dccdc840b935a"
    sha256 cellar: :any,                 arm64_sequoia: "eca1d15906d7c6c2c6c2b01e0a2b7508ff73e03f973ed35234d616f62cd6f2ef"
    sha256 cellar: :any,                 arm64_sonoma:  "eca1d15906d7c6c2c6c2b01e0a2b7508ff73e03f973ed35234d616f62cd6f2ef"
    sha256 cellar: :any,                 sonoma:        "5968595ea60779836c890d3562514f81cacd89482fb0c3e9a2084361ad0337c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c9344d8dad3e528f2d0dbf9909557423dcb9c7fce502edf28427f09378309e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4b1ded47fdb9a603a3b658da272ec00536b57bec1900b28684910c19c9ddabd"
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