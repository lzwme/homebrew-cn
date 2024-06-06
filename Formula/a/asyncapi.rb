require "languagenode"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https:github.comasyncapicli"
  url "https:registry.npmjs.org@asyncapicli-cli-1.17.0.tgz"
  sha256 "899f744258db042ef9d0d078383c9d65a9c9b27ea9041b4d560770a0a5fd903d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "665cd3c7c872d6aeb6f8ecb538f67fe7970c3fc282406bea562cd76c04126faa"
    sha256 cellar: :any,                 arm64_ventura:  "665cd3c7c872d6aeb6f8ecb538f67fe7970c3fc282406bea562cd76c04126faa"
    sha256 cellar: :any,                 arm64_monterey: "665cd3c7c872d6aeb6f8ecb538f67fe7970c3fc282406bea562cd76c04126faa"
    sha256 cellar: :any,                 sonoma:         "cbf42dc5732d0c19dd82ad16e68da138ed17177e81eceef7fc008626d92a66b8"
    sha256 cellar: :any,                 ventura:        "cbf42dc5732d0c19dd82ad16e68da138ed17177e81eceef7fc008626d92a66b8"
    sha256 cellar: :any,                 monterey:       "cbf42dc5732d0c19dd82ad16e68da138ed17177e81eceef7fc008626d92a66b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "342ed396777fc2ea301df648d55087378909fb07815a8ac8391a04ea64037cca"
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