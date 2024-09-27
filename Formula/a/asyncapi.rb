class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https:github.comasyncapicli"
  url "https:registry.npmjs.org@asyncapicli-cli-2.5.0.tgz"
  sha256 "be8fb27577c66e6e667b00ee54bb7d341e3cf8dedec2b22d3deb7b9dccad78d5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "15cf4cbabe113edcc1c243999327d3b6db01ec6ed6bc38bbbea0d4f4278eed8f"
    sha256 cellar: :any,                 arm64_sonoma:  "15cf4cbabe113edcc1c243999327d3b6db01ec6ed6bc38bbbea0d4f4278eed8f"
    sha256 cellar: :any,                 arm64_ventura: "15cf4cbabe113edcc1c243999327d3b6db01ec6ed6bc38bbbea0d4f4278eed8f"
    sha256 cellar: :any,                 sonoma:        "21d5585b4ab3a25a60b0d5176099655dbfbb97a127f8a9cd6be4753f31a38739"
    sha256 cellar: :any,                 ventura:       "21d5585b4ab3a25a60b0d5176099655dbfbb97a127f8a9cd6be4753f31a38739"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3f6e54350bc1ca853fe1b19f3a7b11dbc821809d5cc512b58c3cd84f3519cb3"
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