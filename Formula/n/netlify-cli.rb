require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-16.3.1.tgz"
  sha256 "92d68300fe596541bdd3f15e3ea155de0ce7af857d4be7648d4e1991cdd025bd"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_ventura:  "e33ebdc084885368ce34b0b17f1f0c68d7fc780833e3c25a4f48e061ed26740a"
    sha256                               arm64_monterey: "b5756ae7fc8e0e6013695d9e82e699e9e4f48ad1c05cbdf4a28d8953ddb92ce8"
    sha256                               arm64_big_sur:  "deecbe8bea0d1e09df48495595eadcc57ffc049ab12bc55413a01de2d2178b35"
    sha256                               ventura:        "2c64f5d1018debfb7957002f37233479d2fb2be268e61b28d1c9bab392073d52"
    sha256                               monterey:       "e040ce31b78ab9d085bcf8d96855ad155a273339515354fe8beec452773033d7"
    sha256                               big_sur:        "de9eac8ad49f35e01238c836a83ac6eef1923779fe87d5fecabb0fff086e5ef3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22ad865a1a910c41c9ec264ccbf073ecca1049bd22d66fc892c39324a92ac966"
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