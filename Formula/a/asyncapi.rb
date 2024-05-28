require "languagenode"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https:github.comasyncapicli"
  url "https:registry.npmjs.org@asyncapicli-cli-1.15.4.tgz"
  sha256 "1025848ea0adda0a1908dcbc838cd87827f46455f13d7e30d5c50e513490af23"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "516a11c0844f7b158fa1c2f41091b2da23a8518a00aa7a5bfbd36432e841441f"
    sha256 cellar: :any,                 arm64_ventura:  "516a11c0844f7b158fa1c2f41091b2da23a8518a00aa7a5bfbd36432e841441f"
    sha256 cellar: :any,                 arm64_monterey: "516a11c0844f7b158fa1c2f41091b2da23a8518a00aa7a5bfbd36432e841441f"
    sha256 cellar: :any,                 sonoma:         "b72b81e41a440d4e8c6b8efdd94478c5ed1077e4b1c585c793782f55439269e9"
    sha256 cellar: :any,                 ventura:        "b72b81e41a440d4e8c6b8efdd94478c5ed1077e4b1c585c793782f55439269e9"
    sha256 cellar: :any,                 monterey:       "b72b81e41a440d4e8c6b8efdd94478c5ed1077e4b1c585c793782f55439269e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49368c3ad9ecb3807b53a2f8556468f40a2c9ddd7e30aa748578916fd3b16744"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    system bin"asyncapi", "new", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_predicate testpath"asyncapi.yml", :exist?, "AsyncAPI file was not created"
  end
end