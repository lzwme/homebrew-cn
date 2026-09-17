class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-0.43.0.tgz"
  sha256 "225bc17f06243edf6bcf0fc82bbe8838cab1cd426eb8e467e9ebab93d53ace90"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "2f18e24872ab25f4a616779d3da11598ab3b64ae7910291c07d0d218e7f806b2"
    sha256 cellar: :any,                 arm64_tahoe:       "2f18e24872ab25f4a616779d3da11598ab3b64ae7910291c07d0d218e7f806b2"
    sha256 cellar: :any,                 arm64_sequoia:     "2f18e24872ab25f4a616779d3da11598ab3b64ae7910291c07d0d218e7f806b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3e9b6ecb2f2c5cfd9175a6a2d58637edf054294792261d5872ef5795be9b97e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "b768ec9ea033568ea46f7c23673deeb0db4d3b07b5b4248b06e58b784f61d6e7"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir[libexec/"bin/*"]

    if OS.mac?
      kimi_code_prefix = libexec/"lib/node_modules/@moonshot-ai/kimi-code"
      node_modules = kimi_code_prefix/"node_modules"

      # Remove non-native architecture binaries from `node-pty` and `native`
      other_arch = Hardware::CPU.arm? ? "x64" : "arm64"
      rm_r node_modules/"node-pty/prebuilds/darwin-#{other_arch}"
      rm_r kimi_code_prefix/"native/darwin/prebuilds/darwin-#{other_arch}"

      # Strip universal binary to native architecture for `clipboard`
      deuniversalize_machos "#{node_modules}/@mariozechner/clipboard-darwin-universal/clipboard.darwin-universal.node"
    end
  end

  test do
    # Chokidar's `fs.watch` crashes without FSEvents access in the macOS sandbox
    ENV["CHOKIDAR_USEPOLLING"] = "1" if OS.mac?

    assert_match version.to_s, shell_output("#{bin}/kimi --version")
    assert_match "No providers configured", shell_output("#{bin}/kimi provider list")
    assert_match "No model configured", shell_output("#{bin}/kimi --prompt hello 2>&1", 1)
  end
end