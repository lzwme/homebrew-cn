require "languagenode"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https:github.comavwowhistle"
  url "https:registry.npmjs.orgwhistle-whistle-2.9.63.tgz"
  sha256 "f3a180816d48666ddc91e83588d477d3a296cc92cf91c06774a986ad2a5ac785"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "603bc3755ed2215354d27465b7fbea2a20f386967e297b99fd28fd652ea5d77f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "603bc3755ed2215354d27465b7fbea2a20f386967e297b99fd28fd652ea5d77f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "603bc3755ed2215354d27465b7fbea2a20f386967e297b99fd28fd652ea5d77f"
    sha256 cellar: :any_skip_relocation, sonoma:         "7132967fd5692a5a88128d6723fbdcc77255e769270745891405789218bf072f"
    sha256 cellar: :any_skip_relocation, ventura:        "7132967fd5692a5a88128d6723fbdcc77255e769270745891405789218bf072f"
    sha256 cellar: :any_skip_relocation, monterey:       "7132967fd5692a5a88128d6723fbdcc77255e769270745891405789218bf072f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7132967fd5692a5a88128d6723fbdcc77255e769270745891405789218bf072f"
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