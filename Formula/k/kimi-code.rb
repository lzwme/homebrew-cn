class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://github.com/MoonshotAI/kimi-code"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-0.14.2.tgz"
  sha256 "e2e5305b2bc638244ff73b7e13520121e9aff742919a00d242d3c761f5ef1836"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e98dcb844b1fd8d83e2e841be96ae3f85a2cb73fadf20319437a3ca12a16546b"
    sha256 cellar: :any,                 arm64_sequoia: "4ad8019dc944c98c71fe82d9142f1490e52995059092cafa388797b30d8fec4a"
    sha256 cellar: :any,                 arm64_sonoma:  "4ad8019dc944c98c71fe82d9142f1490e52995059092cafa388797b30d8fec4a"
    sha256 cellar: :any,                 sonoma:        "c3eba9bf2e40dba5b944355d1572ed2c918ff07dd00dd4178b53555a13446905"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9c38d4bf2c58f25110be23905b3f86999e01bf9e37f2184ce1808132e12e9cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ab0f04ddbd762494e4aa3fe79c670399f8146ab409a7f894ae349a9cb250144"
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