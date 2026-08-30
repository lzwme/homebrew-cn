class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-0.39.1.tgz"
  sha256 "22594a76d0aec0cdabd41050fdd354381c106c48a2f8f5edf98394b4b5e987f7"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "904b32153f00a684202ab058822f2d287ebad3628b1cf0d464bb43c8bc966cc4"
    sha256 cellar: :any,                 arm64_sequoia: "904b32153f00a684202ab058822f2d287ebad3628b1cf0d464bb43c8bc966cc4"
    sha256 cellar: :any,                 arm64_sonoma:  "904b32153f00a684202ab058822f2d287ebad3628b1cf0d464bb43c8bc966cc4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d4e49c378645d39a885dcbb7663881ecce303e2b022a380fa8d16d63b67db22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b37c650cb8845180761019fd236c5d8d427587eb3282d075a8aa5bf2abd6be4"
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
    assert_match version.to_s, shell_output("#{bin}/kimi --version")
    assert_match "No providers configured", shell_output("#{bin}/kimi provider list")
    assert_match "No model configured", shell_output("#{bin}/kimi --prompt hello 2>&1", 1)
  end
end