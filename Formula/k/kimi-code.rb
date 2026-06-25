class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-0.19.1.tgz"
  sha256 "8e284d274083546344e7e841365563a338472db112fb5ca73550458793607443"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2b8f2e27160215a9b994dcd8b4ce6cefa16d22b0b20f6474aebc121fa14d7f02"
    sha256 cellar: :any,                 arm64_sequoia: "0f542a635fd1d1772fe737323b4189aac5e02b1dccd8b136295e21e2b6c66047"
    sha256 cellar: :any,                 arm64_sonoma:  "0f542a635fd1d1772fe737323b4189aac5e02b1dccd8b136295e21e2b6c66047"
    sha256 cellar: :any,                 sonoma:        "6b5afa55af9e71d3228e8c786910a673a4f45a1503694d14bfabf593d0b5d856"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "403fff6a0de52e3e10a77e761501abd44cd0ccbff94ea9bfea9913774de58eee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6db8dc3aa2f098f3f0a6e6595c6db9d5ae90a83422f29748644990a0ae5dc069"
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