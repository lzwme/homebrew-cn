require "languagenode"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https:github.comavwowhistle"
  url "https:registry.npmjs.orgwhistle-whistle-2.9.75.tgz"
  sha256 "f031cb9fe20baa0fce3e75f0d14342dba8fd2c2269860b11ec3fc0fcc24a2ec9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7beadb82bbe322905b7e21d7a5eebab4ae65df71c1603f50be8c73b79e756cfe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7beadb82bbe322905b7e21d7a5eebab4ae65df71c1603f50be8c73b79e756cfe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7beadb82bbe322905b7e21d7a5eebab4ae65df71c1603f50be8c73b79e756cfe"
    sha256 cellar: :any_skip_relocation, sonoma:         "23b788566d3d8ab2997b5198060ca0bc4dbbb6c5e3aa1e786d588e1bf976ce23"
    sha256 cellar: :any_skip_relocation, ventura:        "23b788566d3d8ab2997b5198060ca0bc4dbbb6c5e3aa1e786d588e1bf976ce23"
    sha256 cellar: :any_skip_relocation, monterey:       "e25e199d5b56048b1f8d6132708e5eaa5d753f6d53511c700708e21ce67cd13a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0cd5e9ff4d7c80959b82f883e53b66cbdd49ad64529b0190dd119b873ee341ad"
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