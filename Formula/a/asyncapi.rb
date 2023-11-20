require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.60.2.tgz"
  sha256 "2431397fd46a4427280bb0aab4e2c9c08b7eba63b3603d9291e9a546f8aacc18"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f9a2df974ed3ca1bbf0c656dac05b78f95835f9ff778b26538c7a7ecb8630cda"
    sha256 cellar: :any,                 arm64_ventura:  "f9a2df974ed3ca1bbf0c656dac05b78f95835f9ff778b26538c7a7ecb8630cda"
    sha256 cellar: :any,                 arm64_monterey: "f9a2df974ed3ca1bbf0c656dac05b78f95835f9ff778b26538c7a7ecb8630cda"
    sha256 cellar: :any,                 sonoma:         "42cfe38dd61f9e4d1b6c7a5e58c5cafc12a154f541d3fba3ca0cbdadd968dba1"
    sha256 cellar: :any,                 ventura:        "42cfe38dd61f9e4d1b6c7a5e58c5cafc12a154f541d3fba3ca0cbdadd968dba1"
    sha256 cellar: :any,                 monterey:       "42cfe38dd61f9e4d1b6c7a5e58c5cafc12a154f541d3fba3ca0cbdadd968dba1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4dd00ca85fb2b1dd3cc7a688e42a0ef56c89b185f1159e629ba95c6f82e3d8b8"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Delete native binaries installed by npm, as we dont support `musl` for a `libc` implementation
    node_modules = libexec/"lib/node_modules/@asyncapi/cli/node_modules"
    (node_modules/"@swc/core-linux-x64-musl/swc.linux-x64-musl.node").unlink if OS.linux?

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    system bin/"asyncapi", "new", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_predicate testpath/"asyncapi.yml", :exist?, "AsyncAPI file was not created"
  end
end