require "languagenode"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https:github.comasyncapicli"
  url "https:registry.npmjs.org@asyncapicli-cli-1.8.4.tgz"
  sha256 "a5f1a7d6c0731c079b5ab800adcaed79abc3366e2dacf7372d96d4ff8adf6cb1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9a5b2dd2ef47c1e80bf50462b69bc11105fbfe6decc50b258a2c95b9f5b9778d"
    sha256 cellar: :any,                 arm64_ventura:  "9a5b2dd2ef47c1e80bf50462b69bc11105fbfe6decc50b258a2c95b9f5b9778d"
    sha256 cellar: :any,                 arm64_monterey: "9a5b2dd2ef47c1e80bf50462b69bc11105fbfe6decc50b258a2c95b9f5b9778d"
    sha256 cellar: :any,                 sonoma:         "2374d0f3997cf2e7c7cb3f3c0cf2e9b1978fa4846a06392612ad5af6b291a9d5"
    sha256 cellar: :any,                 ventura:        "2374d0f3997cf2e7c7cb3f3c0cf2e9b1978fa4846a06392612ad5af6b291a9d5"
    sha256 cellar: :any,                 monterey:       "2374d0f3997cf2e7c7cb3f3c0cf2e9b1978fa4846a06392612ad5af6b291a9d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f8af16f4b4409d9d670f43376a454625db693de2354ff199cde72724602c500"
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