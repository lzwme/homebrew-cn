class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https:github.comasyncapicli"
  url "https:registry.npmjs.org@asyncapicli-cli-2.7.2.tgz"
  sha256 "dc707536adeafc850d14b6a938ee97003cd56c81dd73ca9b207868b298ebb51d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7fa9ba91d7f06050d05010942169d9b4550a65fa4c3d4fe7253140b759fe0104"
    sha256 cellar: :any,                 arm64_sonoma:  "7fa9ba91d7f06050d05010942169d9b4550a65fa4c3d4fe7253140b759fe0104"
    sha256 cellar: :any,                 arm64_ventura: "7fa9ba91d7f06050d05010942169d9b4550a65fa4c3d4fe7253140b759fe0104"
    sha256 cellar: :any,                 sonoma:        "7eb117fb2f437dff912873bb16430b7062d328a64a775824394a388da1eb6969"
    sha256 cellar: :any,                 ventura:       "7eb117fb2f437dff912873bb16430b7062d328a64a775824394a388da1eb6969"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b9c2fc932934c9c682ab90d2577d1da4a9040a2af977b7d701ab0a6d55c89f4"
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