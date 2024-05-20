require "languagenode"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https:github.comavwowhistle"
  url "https:registry.npmjs.orgwhistle-whistle-2.9.71.tgz"
  sha256 "e10821d90dc26f2792104dd6fb105197907e758fd50d32829db6fe111e71c3a8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bfd290ed7aa273f89b412dbd3b4ebac62e0eb2b7b853fa5aa536bd1418e4d716"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "52f8324c0a9fd478ee0c1c2e99519016dd84f6ab00085a143d9b0f6d9200f2fd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44a8d719d0a7c2058bce6515066e07a7c1b027f7117087b891fd7f68a78e9282"
    sha256 cellar: :any_skip_relocation, sonoma:         "7c0241b9fc99873f8157beac8e835677101a20df7880fa54b35b0865f1b6641a"
    sha256 cellar: :any_skip_relocation, ventura:        "3c283caaa828cb32b08a41c17c0d6ae38d253bf5bc39318146e6035518109f90"
    sha256 cellar: :any_skip_relocation, monterey:       "11d5fe0503a62e27963b4f1987d2115ee014f709e7f3d915c93dc90879884678"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dae7b54cd22b38328eb9b4e9bc924aab4709dc5cc418b965a8afd80e9ee5c7c5"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]

    # Remove x86 specific optional feature
    node_modules = libexec"libnode_moduleswhistlenode_modules"
    rm_f node_modules"set-global-proxylibmacwhistle" if Hardware::CPU.arm?
  end

  test do
    (testpath"package.json").write('{"name": "test"}')
    system bin"whistle", "start"
    system bin"whistle", "stop"
  end
end