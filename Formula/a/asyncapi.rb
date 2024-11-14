class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https:github.comasyncapicli"
  url "https:registry.npmjs.org@asyncapicli-cli-2.9.0.tgz"
  sha256 "bc02ca668cb63d3b54aeedaf61778aa92ac8962bee421477f84a9223c60e71fa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2dde4ac1ff14a9e1a8e7810076ea4aa8c7e10b55f9d83f1ed722b9f8d113c5f6"
    sha256 cellar: :any,                 arm64_sonoma:  "2dde4ac1ff14a9e1a8e7810076ea4aa8c7e10b55f9d83f1ed722b9f8d113c5f6"
    sha256 cellar: :any,                 arm64_ventura: "2dde4ac1ff14a9e1a8e7810076ea4aa8c7e10b55f9d83f1ed722b9f8d113c5f6"
    sha256 cellar: :any,                 sonoma:        "20c16be1e56eef820c8769ed65546fa8d5379fcfb8755a4ed9310d0a43033cd1"
    sha256 cellar: :any,                 ventura:       "20c16be1e56eef820c8769ed65546fa8d5379fcfb8755a4ed9310d0a43033cd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d8bf7ad699005e4a1bad1fdf35802529634a86ad8652cff9d1faf87b4256420"
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