require "languagenode"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https:github.comasyncapicli"
  url "https:registry.npmjs.org@asyncapicli-cli-1.16.0.tgz"
  sha256 "6705d16cf2ec965e5a3e9ba669807d630d213d4c61142fc5d53c53cda042d925"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b85846f798e7bc3ffccb31ecdf0d76ebf6a74ea9d4f4821e0c6edbcd3879da9a"
    sha256 cellar: :any,                 arm64_ventura:  "b85846f798e7bc3ffccb31ecdf0d76ebf6a74ea9d4f4821e0c6edbcd3879da9a"
    sha256 cellar: :any,                 arm64_monterey: "b85846f798e7bc3ffccb31ecdf0d76ebf6a74ea9d4f4821e0c6edbcd3879da9a"
    sha256 cellar: :any,                 sonoma:         "c587bbc69f05945a6cafb2ccdf40625e29f173a6c949d739c46dd091d1e097d7"
    sha256 cellar: :any,                 ventura:        "c587bbc69f05945a6cafb2ccdf40625e29f173a6c949d739c46dd091d1e097d7"
    sha256 cellar: :any,                 monterey:       "c587bbc69f05945a6cafb2ccdf40625e29f173a6c949d739c46dd091d1e097d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96d42b9a96403bfd5e0936d7fbe0e1c2f3815ac6733ed0c65f6b58889ee7f7dc"
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