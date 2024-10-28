class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https:github.comasyncapicli"
  url "https:registry.npmjs.org@asyncapicli-cli-2.8.0.tgz"
  sha256 "04f18ab4062541442661467ea467ad62d1f8b5b261f9b2919fc1ba7db8d6f4c4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ddaa6d718d5c633a94c83db42a6ec1325ecaa5b4a862c4c36094e12b4ce8d5b2"
    sha256 cellar: :any,                 arm64_sonoma:  "ddaa6d718d5c633a94c83db42a6ec1325ecaa5b4a862c4c36094e12b4ce8d5b2"
    sha256 cellar: :any,                 arm64_ventura: "ddaa6d718d5c633a94c83db42a6ec1325ecaa5b4a862c4c36094e12b4ce8d5b2"
    sha256 cellar: :any,                 sonoma:        "d77f22ef7ed880aaf5141c0e0850f5c6da53f1f34041a75211ce29e46a587506"
    sha256 cellar: :any,                 ventura:       "d77f22ef7ed880aaf5141c0e0850f5c6da53f1f34041a75211ce29e46a587506"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87641f381eb6508f230419312facaa53b5542cd7d704c665d56a0053f5bc0a45"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    system bin"asyncapi", "new", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_predicate testpath"asyncapi.yml", :exist?, "AsyncAPI file was not created"
  end
end