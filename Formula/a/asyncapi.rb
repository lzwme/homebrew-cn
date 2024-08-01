require "languagenode"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https:github.comasyncapicli"
  url "https:registry.npmjs.org@asyncapicli-cli-2.3.0.tgz"
  sha256 "9b475fec1610c43156e5b6346d8d0fc644a7361d8ba0c9f5249cb60ffeb4fddc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1b314da55dd64c73574a3b7d9feaf9f5ef13d6edcfeda2d81a1106664972c6c6"
    sha256 cellar: :any,                 arm64_ventura:  "1b314da55dd64c73574a3b7d9feaf9f5ef13d6edcfeda2d81a1106664972c6c6"
    sha256 cellar: :any,                 arm64_monterey: "1b314da55dd64c73574a3b7d9feaf9f5ef13d6edcfeda2d81a1106664972c6c6"
    sha256 cellar: :any,                 sonoma:         "ef50523d7fb7bf3ffc52390cd75bfbe41626894768fc0e54becb12f1d2993117"
    sha256 cellar: :any,                 ventura:        "ef50523d7fb7bf3ffc52390cd75bfbe41626894768fc0e54becb12f1d2993117"
    sha256 cellar: :any,                 monterey:       "73b8527d77413c3ae05796d17d9906ac87205302c300308239c72c2cc6b1aa51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "189f883b8a525744b6159180d469b82bed8895dd451e8c5d3473c057e08aed1a"
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