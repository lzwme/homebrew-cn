class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-0.21.0.tgz"
  sha256 "350b52b0d88bd4be3a37d386e7c8ab3183edb74ad61c0c7fe80203896f859483"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "74ae76b021777a1c7743417f40e286746b74f5d79e3f9dfd18acc0f0573ba3a9"
    sha256 cellar: :any,                 arm64_sequoia: "08a390d3758893436ec0488a3803f694a0aece19cc570524f500e7d89489738a"
    sha256 cellar: :any,                 arm64_sonoma:  "08a390d3758893436ec0488a3803f694a0aece19cc570524f500e7d89489738a"
    sha256 cellar: :any,                 sonoma:        "1d47cff3d799d5a55453a0904c8591bda8ff0118ca8dab36ad27464b8c876be5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db1e4428c933d0237d16df1992e98f7b56ca2914f016bd8ea56d4588f5c5f3e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49309dcd88fe32dcc4d45105881cff7abe73804fb98cf985291c3befb79c2cf1"
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