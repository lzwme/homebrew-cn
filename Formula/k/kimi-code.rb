class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-0.19.2.tgz"
  sha256 "9754ea46915f41d801535f7465ef6b5f53ff7844520663c0858a7136221742ff"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5a96cde0b42c2c53fdab75d3929e3d1130a3c5bd3bfc43cb51f8dd35c62b3adc"
    sha256 cellar: :any,                 arm64_sequoia: "a03229abb0d5745ffc55d149b6bb61ffad7d67e371766b61489b2889ffb3dbce"
    sha256 cellar: :any,                 arm64_sonoma:  "a03229abb0d5745ffc55d149b6bb61ffad7d67e371766b61489b2889ffb3dbce"
    sha256 cellar: :any,                 sonoma:        "f8e468e4e697d726e19ecaa2056385b15fbc28f6d61e2d5c2f5af96aefb331c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a082d48837d85d8e64cd1127bf9a234ac8d5ffd6dad2eb66ef01cd101decb26f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ad03f898f74c6123e284dc129c05d7f2e378373e2e3a7c05fd194b8317c119b"
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