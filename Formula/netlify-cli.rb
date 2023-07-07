require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-15.8.1.tgz"
  sha256 "6fee363bb744d39868648a128836861facfda701e64ec080239805e38246a48c"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_ventura:  "ee44314a7602aee920c5b6ef8d235382043ad920aaeebf1463b4027347e3b1fd"
    sha256                               arm64_monterey: "c1ceb8b68275fc736d83c94fb469a8fb85b9a27d1ff67faa9593912ba9e6267b"
    sha256                               arm64_big_sur:  "9a7564c14692d475f8ebc088641e3e421958c411373424b230b30ce7f3c53363"
    sha256                               ventura:        "72b2187e732c9ff25f606a570fc0cc7e1467903b1deae5b34656e27788d8b306"
    sha256                               monterey:       "1c4fb830776854a59c3982a0dc75044ce1f4fe5ba524b7cf8e60a6593d850a2a"
    sha256                               big_sur:        "9b97d7a2bc82be33a47cb80481e86317938ee2daecf9ced2c34000fa5fb1b7eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "326492d350d9c3063a42778bd54a4ee77d6bc5a55d499561124320031fe18e42"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Not logged in. Please log in to see site status.", shell_output("#{bin}/netlify status")
  end
end