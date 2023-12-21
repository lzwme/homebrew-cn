require "languagenode"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https:github.comasyncapicli"
  url "https:registry.npmjs.org@asyncapicli-cli-1.2.26.tgz"
  sha256 "9b788ef97a70bd39877892574bca9275cd48e5ed7e15ded419397490c72026e2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4abdf61885e20e6bc0ddb219fbcffe12f5e472aa32ae1b29fa0f77dae693109c"
    sha256 cellar: :any,                 arm64_ventura:  "4abdf61885e20e6bc0ddb219fbcffe12f5e472aa32ae1b29fa0f77dae693109c"
    sha256 cellar: :any,                 arm64_monterey: "4abdf61885e20e6bc0ddb219fbcffe12f5e472aa32ae1b29fa0f77dae693109c"
    sha256 cellar: :any,                 sonoma:         "da8676be11e738d50d78f6a9493bcdf17fef5bdb3af16a7534a3f5d828cb4570"
    sha256 cellar: :any,                 ventura:        "da8676be11e738d50d78f6a9493bcdf17fef5bdb3af16a7534a3f5d828cb4570"
    sha256 cellar: :any,                 monterey:       "da8676be11e738d50d78f6a9493bcdf17fef5bdb3af16a7534a3f5d828cb4570"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e66b7f0da51d4ce0bfa0dfcc8f581316e72bc492ab50e525af90fe3502608a9"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]

    # Delete native binaries installed by npm, as we dont support `musl` for a `libc` implementation
    node_modules = libexec"libnode_modules@asyncapiclinode_modules"
    (node_modules"@swccore-linux-x64-muslswc.linux-x64-musl.node").unlink if OS.linux?

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    system bin"asyncapi", "new", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_predicate testpath"asyncapi.yml", :exist?, "AsyncAPI file was not created"
  end
end