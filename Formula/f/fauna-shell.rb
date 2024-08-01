class FaunaShell < Formula
  desc "Interactive shell for FaunaDB"
  homepage "https:fauna.com"
  url "https:registry.npmjs.orgfauna-shell-fauna-shell-2.0.1.tgz"
  sha256 "59c1e4cd508c96cd8072c22e18577a300b5b1debed1db313074ff52ed7312365"
  license "MPL-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fe1c37e6040b4be169be9ded1df46a08a5cf0bd21ae8a3c63e6d1a267c80decf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fe1c37e6040b4be169be9ded1df46a08a5cf0bd21ae8a3c63e6d1a267c80decf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe1c37e6040b4be169be9ded1df46a08a5cf0bd21ae8a3c63e6d1a267c80decf"
    sha256 cellar: :any_skip_relocation, sonoma:         "2523748bab8aaa58da93d3bbb248cd50ce1325620c4adea80c86d1271a8df3e3"
    sha256 cellar: :any_skip_relocation, ventura:        "2523748bab8aaa58da93d3bbb248cd50ce1325620c4adea80c86d1271a8df3e3"
    sha256 cellar: :any_skip_relocation, monterey:       "2523748bab8aaa58da93d3bbb248cd50ce1325620c4adea80c86d1271a8df3e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8984692ddd3d69b5ca9bc672f01ecf18d89560ee88d917195c41263c536b2af1"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    output = shell_output("#{bin}fauna endpoint list 2>&1")
    assert_match "Available endpoints:\n", output

    # FIXME: This test seems to stall indefinitely on Linux.
    # https:github.comjdxcodepassword-promptissues12
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    output = shell_output("#{bin}fauna endpoint add https:db.fauna.com:443 " \
                          "--non-interactive --url http:localhost:8443 " \
                          "--secret your_fauna_secret --set-default")
    assert_match "Saved endpoint https:db.fauna.com:443", output

    expected = <<~EOS
      Available endpoints:
      * https:db.fauna.com:443
    EOS
    assert_equal expected, shell_output("#{bin}fauna endpoint list")
  end
end