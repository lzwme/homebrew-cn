require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.1.13.tgz"
  sha256 "719abbb116c09f2f86c2bda7d1a7c231fd491df0d8ea5c8a96fb60de050c3388"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a5a1452ff5500bd0d571848b919dcbe87290609f838074de69085d61b6ea29ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a5a1452ff5500bd0d571848b919dcbe87290609f838074de69085d61b6ea29ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5a1452ff5500bd0d571848b919dcbe87290609f838074de69085d61b6ea29ff"
    sha256 cellar: :any_skip_relocation, sonoma:         "b709e64fdb8b37e2fa0683124977830dd67563bd7fd439ab3dab9cd0b4176401"
    sha256 cellar: :any_skip_relocation, ventura:        "b709e64fdb8b37e2fa0683124977830dd67563bd7fd439ab3dab9cd0b4176401"
    sha256 cellar: :any_skip_relocation, monterey:       "b709e64fdb8b37e2fa0683124977830dd67563bd7fd439ab3dab9cd0b4176401"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5a1452ff5500bd0d571848b919dcbe87290609f838074de69085d61b6ea29ff"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end