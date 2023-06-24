require "language/node"

class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://github.com/alexa/ask-cli"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-2.30.2.tgz"
  sha256 "42373b1309183359db79b246b938c1532b7c8ddf30c414cf3545fd3dbcea4dae"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1e9564b5be50320be297a85246b9bfd39457b86f961d9543d9386b15fc92796b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe4df3fe0bdeebede096180a70eb552d72b93f4c3c85f97898bcd088cb481f2a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "74f91952911139a1910f00374d83e3ac52fea15a293f2f5a0cfa7e9b34ab05b8"
    sha256 cellar: :any_skip_relocation, ventura:        "103903e562a8c912384903e9b09e320386ae9f7ee224f79bc4fd9002a9a7436a"
    sha256 cellar: :any_skip_relocation, monterey:       "eb2f6c61c03e13cabc41ce65d19dbbc2122ee4c6b166d051909c95f4f2061d0a"
    sha256 cellar: :any_skip_relocation, big_sur:        "bff0b28018b3059b0faf9ccf42dc2cf643e42412a26834ccca6a2e397d4ebac3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef3b14aff08e08a5fd3e0eafebaf269b337d2533b77cba46b743955049083b4d"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.write_exec_script libexec/"bin/ask"

    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    output = shell_output("#{bin}/ask deploy 2>&1", 1)
    assert_match "File #{testpath}/.ask/cli_config not exists.", output
  end
end