require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-16.6.1.tgz"
  sha256 "9919f3f0e95cfddf5199c05f205ee94b4c17560e97ba697fbe5876e5d4a30b10"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "2801693632c93acfc59153f1c52d7dacf74960ef25a4bbee6c043b8fa0469473"
    sha256                               arm64_ventura:  "001e41b0d8467955433fac3944e37db5c0bdbd1387fbc2e5713ad2539651cfaf"
    sha256                               arm64_monterey: "6526b43cfbfdd4fcf80abd82b4d1b474ae08c50008ea1aff5b6c9e59318455ba"
    sha256                               sonoma:         "546b1a0373638c742cd269a25834938691ad1656035e915ac3c9f65cd8cfa039"
    sha256                               ventura:        "b7ccba70344f0bc9e7bc586246d5a265bd449ed83ab9abfdc76752cd8a4bf523"
    sha256                               monterey:       "65d3ef1f01e75e381856b4f39e1ff19b57add02549ba66039d0a9f84edb62752"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02dbab9b028e42029747983c67c3fc3aa0d04914862f6d77f9e9f8c053eb75bd"
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