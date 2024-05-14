require "languagenode"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https:github.comasyncapicli"
  url "https:registry.npmjs.org@asyncapicli-cli-1.12.3.tgz"
  sha256 "191a24af5005f43074a44ce9cc616c18f9438a2641fe7a86aa32d74db3b3e2f0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b46497135ee6e4a2d370e5ccde6d4c87e5cc48d1e02b1670ba3ee227520d4c15"
    sha256 cellar: :any,                 arm64_ventura:  "32c84f94c7454f88a4ab2f682c2091b53842d8c3055d85ae0aaa4df1f08ca38b"
    sha256 cellar: :any,                 arm64_monterey: "1b6f4b126234721247969ab9df0d553edadc30907b8c17569949402d40e1f554"
    sha256 cellar: :any,                 sonoma:         "1ac570304c8d1e12448397efcfd7af8b72c9796d9435888abc1fec1bcf861e6c"
    sha256 cellar: :any,                 ventura:        "67bfd162eacfa263d2091ce642caa73b1ec311e6aabb83f6358ec09ffc1f167b"
    sha256 cellar: :any,                 monterey:       "0f5f53c865db7f2414b5bdd25e1ff22bae4dc8ccdfe6483c806724f388393763"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80151acfc87f6f43e8dbedb851e5b6373df981b45b5f9f625d0469ecc2a37979"
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