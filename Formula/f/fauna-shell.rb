require "language/node"

class FaunaShell < Formula
  desc "Interactive shell for FaunaDB"
  homepage "https://fauna.com/"
  url "https://registry.npmjs.org/fauna-shell/-/fauna-shell-1.0.0.tgz"
  sha256 "5cc3bd87d8793b7057c94b08e4b01a3e3f5f3936b5e392890cceb2be0e5494fb"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "95898d2e13116a056a12763de76e8e79d74a5b8f1d7cc686e6976934fc17cb4f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95898d2e13116a056a12763de76e8e79d74a5b8f1d7cc686e6976934fc17cb4f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "95898d2e13116a056a12763de76e8e79d74a5b8f1d7cc686e6976934fc17cb4f"
    sha256 cellar: :any_skip_relocation, ventura:        "a2a2a3100cdc634f7d86923b81451794e7d90e48ece623b4750dd5a9be8a16a9"
    sha256 cellar: :any_skip_relocation, monterey:       "a2a2a3100cdc634f7d86923b81451794e7d90e48ece623b4750dd5a9be8a16a9"
    sha256 cellar: :any_skip_relocation, big_sur:        "a2a2a3100cdc634f7d86923b81451794e7d90e48ece623b4750dd5a9be8a16a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95898d2e13116a056a12763de76e8e79d74a5b8f1d7cc686e6976934fc17cb4f"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/fauna list-endpoints 2>&1", 1)
    assert_match "No endpoints defined", output

    # FIXME: This test seems to stall indefinitely on Linux.
    # https://github.com/jdxcode/password-prompt/issues/12
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    pipe_output("#{bin}/fauna add-endpoint https://db.fauna.com:443", "your_fauna_secret\nfauna_endpoint\n")

    output = shell_output("#{bin}/fauna list-endpoints")
    assert_match "fauna_endpoint *\n", output
  end
end