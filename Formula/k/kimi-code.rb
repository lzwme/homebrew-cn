class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-0.21.1.tgz"
  sha256 "568419c6ca064e3007311826ef8884a933212c07e39d43cccdaebf26f8fa6809"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bbc0296e32a921bafc6a3c84af5ccc5118e3cd65ca4908adc60dbbdc1060c4fd"
    sha256 cellar: :any,                 arm64_sequoia: "d4600b7c5e2f13bb36ddb44c0d4ea0d712f67b02d12ef70dc3857925500fed6d"
    sha256 cellar: :any,                 arm64_sonoma:  "d4600b7c5e2f13bb36ddb44c0d4ea0d712f67b02d12ef70dc3857925500fed6d"
    sha256 cellar: :any,                 sonoma:        "f6873f6334e3a20bc00356695deebe289f46b336b6d638b6b3d796c6939b6b81"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "808c40e1788682517870c313a8058cf1e97d000de6d3af40366a080fdf41dbbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd604552e78bc9ffb051794d3036bc61a305848d53f05a4e494a950b4cd30844"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir[libexec/"bin/*"]

    node_modules = libexec/"lib/node_modules/@moonshot-ai/kimi-code/node_modules"

    # Remove non-native architecture binaries from `koffi` and `node-pty`
    if OS.mac?
      other_arch = Hardware::CPU.arm? ? "x64" : "arm64"
      rm_r node_modules/"koffi/build/koffi/darwin_#{other_arch}"
      rm_r node_modules/"node-pty/prebuilds/darwin-#{other_arch}"
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