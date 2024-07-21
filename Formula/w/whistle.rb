require "languagenode"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https:github.comavwowhistle"
  url "https:registry.npmjs.orgwhistle-whistle-2.9.79.tgz"
  sha256 "1e14001d7926e1620fed8c6392596f68244d1dbdcfbf135f761aa143e78325ee"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a11025dd01f85e2253fad0f341f171fd5da122d7996faf1c541e0a56733585bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a11025dd01f85e2253fad0f341f171fd5da122d7996faf1c541e0a56733585bf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a11025dd01f85e2253fad0f341f171fd5da122d7996faf1c541e0a56733585bf"
    sha256 cellar: :any_skip_relocation, sonoma:         "88ebc08dc54cbc652e5d1751d947a239e046c5725f3a3aeefa8ea129a36dc4ca"
    sha256 cellar: :any_skip_relocation, ventura:        "88ebc08dc54cbc652e5d1751d947a239e046c5725f3a3aeefa8ea129a36dc4ca"
    sha256 cellar: :any_skip_relocation, monterey:       "a11025dd01f85e2253fad0f341f171fd5da122d7996faf1c541e0a56733585bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d72927572c0c9f4d503036b646494207fdf9f4a416d643fdc952dc0e1b993e4"
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