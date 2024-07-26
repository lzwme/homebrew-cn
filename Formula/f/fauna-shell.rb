require "languagenode"

class FaunaShell < Formula
  desc "Interactive shell for FaunaDB"
  homepage "https:fauna.com"
  url "https:registry.npmjs.orgfauna-shell-fauna-shell-2.0.1.tgz"
  sha256 "59c1e4cd508c96cd8072c22e18577a300b5b1debed1db313074ff52ed7312365"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "deee3f582ab2840f03b8099a11095b41367d0653bb013304a6bc50059e554eab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "deee3f582ab2840f03b8099a11095b41367d0653bb013304a6bc50059e554eab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "deee3f582ab2840f03b8099a11095b41367d0653bb013304a6bc50059e554eab"
    sha256 cellar: :any_skip_relocation, sonoma:         "ef3939928ff4d3d4bcd28f096ad4eaae2607b95562b2b2ff016d39d77db37b23"
    sha256 cellar: :any_skip_relocation, ventura:        "ef3939928ff4d3d4bcd28f096ad4eaae2607b95562b2b2ff016d39d77db37b23"
    sha256 cellar: :any_skip_relocation, monterey:       "22153a6eb7a9238cf588608e72c88dd52d5deed82501c9ecb3b0c5dc1d9a4cef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e282a512b6ea907e857acb3569d34a27ce4caaf0ba65950145876738bd1367f"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
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