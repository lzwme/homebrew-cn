require "languagenode"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https:github.comasyncapicli"
  url "https:registry.npmjs.org@asyncapicli-cli-2.1.1.tgz"
  sha256 "82c3ca1a869f9718f4ecbab7bb98754ca1adb51a99b1b2ea7c9271b71ed35099"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4e60cc92d8609bdaa142ee7b8ed44b00dd2ec06bee1832f3d59f6dbb824a0521"
    sha256 cellar: :any,                 arm64_ventura:  "4e60cc92d8609bdaa142ee7b8ed44b00dd2ec06bee1832f3d59f6dbb824a0521"
    sha256 cellar: :any,                 arm64_monterey: "4e60cc92d8609bdaa142ee7b8ed44b00dd2ec06bee1832f3d59f6dbb824a0521"
    sha256 cellar: :any,                 sonoma:         "4d1cffae24c9c91d87be6fe8a6c877615d27e8e124b27007197d1015ff113671"
    sha256 cellar: :any,                 ventura:        "4d1cffae24c9c91d87be6fe8a6c877615d27e8e124b27007197d1015ff113671"
    sha256 cellar: :any,                 monterey:       "4d1cffae24c9c91d87be6fe8a6c877615d27e8e124b27007197d1015ff113671"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "196a18314e9fc6ae3e4a1638a30691f264c5002a6f351230e3e58143f355ea89"
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