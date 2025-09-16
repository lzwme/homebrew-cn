class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-0.9.0.tgz"
  sha256 "10085c6390224581e5716dce15aaf041b9fe0a0064dc8e951282132b5ac5292c"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "0fc9d2efecc9d131ce605e2652ce798a4e8d19a11e58ea4e5820df9e85b62026"
    sha256                               arm64_sequoia: "0fc9d2efecc9d131ce605e2652ce798a4e8d19a11e58ea4e5820df9e85b62026"
    sha256                               arm64_sonoma:  "0fc9d2efecc9d131ce605e2652ce798a4e8d19a11e58ea4e5820df9e85b62026"
    sha256 cellar: :any_skip_relocation, sonoma:        "f036c77cf896d78be59c1f6e6ba5a6053d64f279ceb14a247a09176747a520f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d073e59081bfb7b997a9a94f2e50a46461ec7b1538e34fc9aaaee162f07f9f2a"
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