require "languagenode"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https:github.comavwowhistle"
  url "https:registry.npmjs.orgwhistle-whistle-2.9.77.tgz"
  sha256 "b7dc45125e666c1780013d8349ceb1d01a55828c7aa981a264fea3631bd9f492"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cdee9329140857cd423cdec84b8505602e8d2748da8cd157c318d7e6c5871517"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cdee9329140857cd423cdec84b8505602e8d2748da8cd157c318d7e6c5871517"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cdee9329140857cd423cdec84b8505602e8d2748da8cd157c318d7e6c5871517"
    sha256 cellar: :any_skip_relocation, sonoma:         "cdee9329140857cd423cdec84b8505602e8d2748da8cd157c318d7e6c5871517"
    sha256 cellar: :any_skip_relocation, ventura:        "cdee9329140857cd423cdec84b8505602e8d2748da8cd157c318d7e6c5871517"
    sha256 cellar: :any_skip_relocation, monterey:       "cdee9329140857cd423cdec84b8505602e8d2748da8cd157c318d7e6c5871517"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9bec69c4c50a8b1041cb1826b8b8d7eaa105028734b252dac7a64c377925e1be"
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