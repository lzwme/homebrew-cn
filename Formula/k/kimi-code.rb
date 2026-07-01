class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-0.20.2.tgz"
  sha256 "9eaa91025c23951f008edfca488f0ddf163a29905f61c2fbb7773628d48f6bdf"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c32c0f2196eee1b60da9b34ef9aac86bada837b13b30d37f82489f35a14535b4"
    sha256 cellar: :any,                 arm64_sequoia: "e5f0a8675d61abe1d56f74e976ac0af61b282d21a109dcda8dd994793d7533cd"
    sha256 cellar: :any,                 arm64_sonoma:  "e5f0a8675d61abe1d56f74e976ac0af61b282d21a109dcda8dd994793d7533cd"
    sha256 cellar: :any,                 sonoma:        "f145048ae54409ccd234d7f84d6d8b8ec15483bbd2360de0043aedf09cd0f551"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "175b80268fb9b4f6c6513ce5ba1fb44019517ab172f7d894de35892f94329a73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78aeb4a8e455619ac71c30adaeeecdbd26cdd8cdbc917fe14d1e890d3d7cd35d"
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