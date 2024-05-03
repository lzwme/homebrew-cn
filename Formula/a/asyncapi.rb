require "languagenode"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https:github.comasyncapicli"
  url "https:registry.npmjs.org@asyncapicli-cli-1.11.0.tgz"
  sha256 "86e279256887779ac12caca3a2b81ec8ba77d3fb62f691fdd906c7393fd2d3b3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e6a2264ffa1dceef259895114878c1e004e3d0396a8c8b1ed5ef1fefe3173be3"
    sha256 cellar: :any,                 arm64_ventura:  "e6a2264ffa1dceef259895114878c1e004e3d0396a8c8b1ed5ef1fefe3173be3"
    sha256 cellar: :any,                 arm64_monterey: "e6a2264ffa1dceef259895114878c1e004e3d0396a8c8b1ed5ef1fefe3173be3"
    sha256 cellar: :any,                 sonoma:         "fa9495ea6b4c98517c3e0309a8fd516b108cd59f1e920f952fc5503abc8d4f68"
    sha256 cellar: :any,                 ventura:        "fa9495ea6b4c98517c3e0309a8fd516b108cd59f1e920f952fc5503abc8d4f68"
    sha256 cellar: :any,                 monterey:       "fa9495ea6b4c98517c3e0309a8fd516b108cd59f1e920f952fc5503abc8d4f68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d8133e63bad8c544f235c78b837152190f94dd66d0a7a20ec7e9b7742c8d6d4"
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