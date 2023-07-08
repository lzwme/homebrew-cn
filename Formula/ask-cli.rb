require "language/node"

class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://github.com/alexa/ask-cli"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-2.30.4.tgz"
  sha256 "373384c38cd96671237c645857e19969202c060e928dc1fd5d0efd9f6ae47502"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "40978a5938252c834a31a64c5a5514b57d439e0c0aa1dad7fdc2ef39e9a1146b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c913df1e848a5d0d39147675872eba2dca66b28746c211e431fe0fbac882020"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6ee9e765fe0e88d6d1325fd83a8a0dc38ebb11abd412adf96df0b91dcf821cc6"
    sha256 cellar: :any_skip_relocation, ventura:        "e751e0828c36715e136d1f094dd0c159e8437e3875aa608d69002f92fa972936"
    sha256 cellar: :any_skip_relocation, monterey:       "2cd41d5aa806c0b5c7790a732800fdd7892212f07988dcdd48592111742d3944"
    sha256 cellar: :any_skip_relocation, big_sur:        "3b40393a917788618ce664292fa53df2753f723645ec2247edba0c63f5127bef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91ec8703bdc28bb9006e32a68778a6a5d899b661cdbb6e157eff87c19ca0f301"
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