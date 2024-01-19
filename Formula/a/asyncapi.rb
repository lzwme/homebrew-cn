require "languagenode"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https:github.comasyncapicli"
  url "https:registry.npmjs.org@asyncapicli-cli-1.3.3.tgz"
  sha256 "1edac7400a95c0e134ac3963845c00ba88c08cc55aedd57b1487f65b1ee9ced1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "075b11058b10202b95a286f386382b6c10b74ca306e797089a16e9416d4ab606"
    sha256 cellar: :any,                 arm64_ventura:  "075b11058b10202b95a286f386382b6c10b74ca306e797089a16e9416d4ab606"
    sha256 cellar: :any,                 arm64_monterey: "075b11058b10202b95a286f386382b6c10b74ca306e797089a16e9416d4ab606"
    sha256 cellar: :any,                 sonoma:         "c46582dd1798e80f1b565f16fe252bd9f5931e112b4feebc5391b10e44de8e34"
    sha256 cellar: :any,                 ventura:        "c46582dd1798e80f1b565f16fe252bd9f5931e112b4feebc5391b10e44de8e34"
    sha256 cellar: :any,                 monterey:       "c46582dd1798e80f1b565f16fe252bd9f5931e112b4feebc5391b10e44de8e34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac951fccd646f68a30c4ff36f08511ac2843f1f34356d4ef830c2092eada4d53"
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