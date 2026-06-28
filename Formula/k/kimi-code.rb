class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-0.20.1.tgz"
  sha256 "a5dac9504c0c7f058e1a7295985bdb3dfce3d4de1b17aabcc865793d1e691f7b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1dfb56385bf30abee018ca1adb08e10b50858ea6847d5860eda9d07ac281bec5"
    sha256 cellar: :any,                 arm64_sequoia: "3ac22442fd91ccb4573cbd7c4f294b30b2008cfd93ca94dc12fa9eb4c6c75f66"
    sha256 cellar: :any,                 arm64_sonoma:  "3ac22442fd91ccb4573cbd7c4f294b30b2008cfd93ca94dc12fa9eb4c6c75f66"
    sha256 cellar: :any,                 sonoma:        "7566d82716f1e4c0ef6159959e850da8f0d651250f812f7fb2c21c847bcdbf33"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4d144f5bbbf96895cdbfb0d2622ba331ef6b3dbea1bc799ed0e887253f95771"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "160f22fe1df2fbca610937a31607e6309ca69e3c78864fc22224265d70835082"
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