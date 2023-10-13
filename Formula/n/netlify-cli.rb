require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-16.7.0.tgz"
  sha256 "292916aa241501eb596e755346437a725408fa5d9c3d20551836934515524402"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "b5cb42d7e863570653aef996b648868633ff5a33b6cbd9c9bd96610d8c9e5a8c"
    sha256                               arm64_ventura:  "c53f7157c95f337d7f4169a38d5f62e48ce0dd319aa7064bb9df6acd4d48fb45"
    sha256                               arm64_monterey: "481bbd23ee0bf675bbfe6ad01f67606843d8faa8cf0af00c5faa13f5ed16460f"
    sha256                               sonoma:         "176c58e22bb5ca1872080b980e0c557fcc4cf74b59ae93b5dd04e12fed90bdbe"
    sha256                               ventura:        "1bd0467dec833d2f0d81ae2c96d4ae06dcb7e8dcb62e3eed23e52caab9d66337"
    sha256                               monterey:       "d95aaaad5749cd42ea51986489759519489904b6cc85f22d7d5de1a7bde7c3a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08143aa3d39d342f8e244e6767397bf653dc27ca2743ae7ee78b58e0b3ee16ae"
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