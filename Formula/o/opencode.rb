class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-0.15.7.tgz"
  sha256 "652d0550cd662c1770283c9b9e93ab4c01cd9895d8bcc9b7b4533f9da4ade241"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "d41911f35f00fc70e26a698d40e7ccbd006c130ee668faffc5dabed044656617"
    sha256                               arm64_sequoia: "d41911f35f00fc70e26a698d40e7ccbd006c130ee668faffc5dabed044656617"
    sha256                               arm64_sonoma:  "d41911f35f00fc70e26a698d40e7ccbd006c130ee668faffc5dabed044656617"
    sha256 cellar: :any_skip_relocation, sonoma:        "d501ce435e43265120fc73fffb05a1e4affc670f6e7db1d84b199e7393e1c32f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "157cdc2f0d15828abe97bf1339d6f8dd414064ae340a107043de6419768b70d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe90e3de58b07551ad4be40ad7ac0746be2a345a10fc7167c860f1bcb91a63b5"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opencode --version")
    assert_match "opencode", shell_output("#{bin}/opencode models")
  end
end