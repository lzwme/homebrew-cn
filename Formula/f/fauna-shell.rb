require "languagenode"

class FaunaShell < Formula
  desc "Interactive shell for FaunaDB"
  homepage "https:fauna.com"
  url "https:registry.npmjs.orgfauna-shell-fauna-shell-1.3.1.tgz"
  sha256 "2d86d40e335373f49f20f8684b0e7584859655a70e9e95eeca6bfd727512b365"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ae3c20af2fc302865413eed33da93bfc0bc1e43d8720f06f756a10f155e58f15"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae3c20af2fc302865413eed33da93bfc0bc1e43d8720f06f756a10f155e58f15"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae3c20af2fc302865413eed33da93bfc0bc1e43d8720f06f756a10f155e58f15"
    sha256 cellar: :any_skip_relocation, sonoma:         "28fff4f7c11c221f3be172867d8d04dd1e7ed57b822a70019494472168a13bda"
    sha256 cellar: :any_skip_relocation, ventura:        "28fff4f7c11c221f3be172867d8d04dd1e7ed57b822a70019494472168a13bda"
    sha256 cellar: :any_skip_relocation, monterey:       "a453a5cf840f0879b9823e4994612e07b8cbf53174ea44c762cdc4c7c3c45142"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f635ee4bf318c5a0a06b5fe943723c2b115cf9a35773df8718b84cc6e80f6cca"
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