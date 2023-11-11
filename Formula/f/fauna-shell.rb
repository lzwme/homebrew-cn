require "language/node"

class FaunaShell < Formula
  desc "Interactive shell for FaunaDB"
  homepage "https://fauna.com/"
  url "https://registry.npmjs.org/fauna-shell/-/fauna-shell-1.2.0.tgz"
  sha256 "622bb5cfa89221eab05c5bbcf23c10fc7110c9acafa13e454aa059560aa1e03e"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "af5f454788388317b8f6c9f7919aff58d2dcff28eb18ccc13cc1801d22221dba"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af5f454788388317b8f6c9f7919aff58d2dcff28eb18ccc13cc1801d22221dba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af5f454788388317b8f6c9f7919aff58d2dcff28eb18ccc13cc1801d22221dba"
    sha256 cellar: :any_skip_relocation, sonoma:         "2ecebc28d573a52f7e1abc9567cb34ce89e6ab558797075b46a7f9369c60a3d1"
    sha256 cellar: :any_skip_relocation, ventura:        "2ecebc28d573a52f7e1abc9567cb34ce89e6ab558797075b46a7f9369c60a3d1"
    sha256 cellar: :any_skip_relocation, monterey:       "2ecebc28d573a52f7e1abc9567cb34ce89e6ab558797075b46a7f9369c60a3d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af5f454788388317b8f6c9f7919aff58d2dcff28eb18ccc13cc1801d22221dba"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/fauna endpoint list 2>&1")
    assert_match "Available endpoints:\n", output

    # FIXME: This test seems to stall indefinitely on Linux.
    # https://github.com/jdxcode/password-prompt/issues/12
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    output = shell_output("#{bin}/fauna endpoint add https://db.fauna.com:443 " \
                          "--non-interactive --url http://localhost:8443 " \
                          "--secret your_fauna_secret --set-default")
    assert_match "Saved endpoint https://db.fauna.com:443", output

    expected = <<~EOS
      Available endpoints:
      * https://db.fauna.com:443
    EOS
    assert_equal expected, shell_output("#{bin}/fauna endpoint list")
  end
end