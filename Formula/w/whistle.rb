require "languagenode"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https:github.comavwowhistle"
  url "https:registry.npmjs.orgwhistle-whistle-2.9.72.tgz"
  sha256 "ad6bdb1c8b484f1f3cdaefc32d21a8ee589d6a0e6d29834fe472a7d01cc05eaf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dd543933dc42bf40beeb21ae9997a4a254ee940fe60c072715e3c7f102fc41c2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2a44079999e24c5dc8de403cbcdc487ece7a55003c480e08cddbfa5bedb18600"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f593acf20d16c8ed55d3af92310b96fb13229a90505dc1d8fd52b191f5331df4"
    sha256 cellar: :any_skip_relocation, sonoma:         "63f95872b831810bacb01275efb9b6cbdd88ff395016bd5913f1b5eaecf1eb49"
    sha256 cellar: :any_skip_relocation, ventura:        "75613cd6641463012b45eee6ee1d6acbab22eabed893dea96a9674e97b740b2a"
    sha256 cellar: :any_skip_relocation, monterey:       "078c8ac667619f9cf710b7576ba6675851b54e93625678525a01d86b37fa876c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62c9bba6042b70632031ffbb3e66099c232254c3e269785d1b9ece57337029fc"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]

    # Remove x86 specific optional feature
    node_modules = libexec"libnode_moduleswhistlenode_modules"
    rm_f node_modules"set-global-proxylibmacwhistle" if Hardware::CPU.arm?
  end

  test do
    (testpath"package.json").write('{"name": "test"}')
    system bin"whistle", "start"
    system bin"whistle", "stop"
  end
end