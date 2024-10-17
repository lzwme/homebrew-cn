class FaunaShell < Formula
  desc "Interactive shell for FaunaDB"
  homepage "https:fauna.com"
  url "https:registry.npmjs.orgfauna-shell-fauna-shell-3.0.0.tgz"
  sha256 "a11ec233a3017be819e575620cc37894776e9d2e3c82c63999bd0c9a147554a1"
  license "MPL-2.0"
  head "https:github.comfaunafauna-shell.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d72b247b9e62accbde5a69461efd1f71102ffb422fbfcf2db9b1330f2a5c95c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d72b247b9e62accbde5a69461efd1f71102ffb422fbfcf2db9b1330f2a5c95c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d72b247b9e62accbde5a69461efd1f71102ffb422fbfcf2db9b1330f2a5c95c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "192b96a56a8965da4ee59d211e0364a880da22a3c8b6ed18a437c06740754877"
    sha256 cellar: :any_skip_relocation, ventura:       "192b96a56a8965da4ee59d211e0364a880da22a3c8b6ed18a437c06740754877"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d72b247b9e62accbde5a69461efd1f71102ffb422fbfcf2db9b1330f2a5c95c9"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin*")
  end

  test do
    output = shell_output("#{bin}fauna endpoint list 2>&1")
    assert_match "Available endpoints:\n", output

    # FIXME: This test seems to stall indefinitely on Linux.
    # https:github.comjdxcodepassword-promptissues12
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    output = shell_output("#{bin}fauna endpoint add https:db.fauna.com:443 " \
                          "--no-input --url http:localhost:8443 " \
                          "--secret your_fauna_secret --set-default")
    assert_match "Saved endpoint https:db.fauna.com:443", output

    expected = <<~EOS
      Available endpoints:
      * https:db.fauna.com:443
    EOS
    assert_equal expected, shell_output("#{bin}fauna endpoint list")
  end
end