require "languagenode"

class Mailsy < Formula
  desc "Quickly generate a temporary email address"
  homepage "https:github.comBalliAsgharMailsy"
  url "https:registry.npmjs.orgmailsy-mailsy-4.0.1.tgz"
  sha256 "de0f20fa8ea5594300a9edc07126d375105f270e3572d185ed30e063a2d1adac"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "72f0c13d3a5953ab2626600bae898be73dbce3417fe91afe9ccaca61900e807c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c801001ede7a7404a699e81888f6ecde9dd5dc0ffbbc3bdb3fc7024adc88228"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c801001ede7a7404a699e81888f6ecde9dd5dc0ffbbc3bdb3fc7024adc88228"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5c801001ede7a7404a699e81888f6ecde9dd5dc0ffbbc3bdb3fc7024adc88228"
    sha256 cellar: :any_skip_relocation, sonoma:         "bcbe04e735fe0aedbb8db37c899eac8668965a96bbce81552944c8098d6aaf00"
    sha256 cellar: :any_skip_relocation, ventura:        "d35b5c9608016e132808129f3944b6a21bd4ee669eec2145ccbf68bfeab12cd4"
    sha256 cellar: :any_skip_relocation, monterey:       "d35b5c9608016e132808129f3944b6a21bd4ee669eec2145ccbf68bfeab12cd4"
    sha256 cellar: :any_skip_relocation, big_sur:        "d35b5c9608016e132808129f3944b6a21bd4ee669eec2145ccbf68bfeab12cd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c801001ede7a7404a699e81888f6ecde9dd5dc0ffbbc3bdb3fc7024adc88228"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    assert_match "Account not created yet", shell_output("#{bin}mailsy me")
    assert_match "Account not created yet", shell_output("#{bin}mailsy d")
  end
end