require "languagenode"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https:github.comasyncapicli"
  url "https:registry.npmjs.org@asyncapicli-cli-1.9.1.tgz"
  sha256 "d29102b7c49504148206fa9f50f14f16ccd6e10a829205ca61d8a11df856fa1e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "558c44ece8e665a657be7b9f579bf6ef9b017937f9332240dd62e543c0745e09"
    sha256 cellar: :any,                 arm64_ventura:  "558c44ece8e665a657be7b9f579bf6ef9b017937f9332240dd62e543c0745e09"
    sha256 cellar: :any,                 arm64_monterey: "558c44ece8e665a657be7b9f579bf6ef9b017937f9332240dd62e543c0745e09"
    sha256 cellar: :any,                 sonoma:         "c7478b4f79712e46125d9c91fb3054ceed5de7114f632449a4304eb80be72428"
    sha256 cellar: :any,                 ventura:        "c7478b4f79712e46125d9c91fb3054ceed5de7114f632449a4304eb80be72428"
    sha256 cellar: :any,                 monterey:       "c7478b4f79712e46125d9c91fb3054ceed5de7114f632449a4304eb80be72428"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "508a2c7b2546d5b967b7977b6f89e485fe3ca71e2d431e6ab80af7d3260621fa"
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