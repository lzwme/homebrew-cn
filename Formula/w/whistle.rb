require "languagenode"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https:github.comavwowhistle"
  url "https:registry.npmjs.orgwhistle-whistle-2.9.78.tgz"
  sha256 "0f30d34857e18c6007bb1ec33a5116601ddd1f7b4a79259b8ea8b0fc5ef7eca7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c3570843ed590dcaa696aca4c55f260c99f94e51f4bf93def0edb4812f7c0963"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c3570843ed590dcaa696aca4c55f260c99f94e51f4bf93def0edb4812f7c0963"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c3570843ed590dcaa696aca4c55f260c99f94e51f4bf93def0edb4812f7c0963"
    sha256 cellar: :any_skip_relocation, sonoma:         "c3570843ed590dcaa696aca4c55f260c99f94e51f4bf93def0edb4812f7c0963"
    sha256 cellar: :any_skip_relocation, ventura:        "c3570843ed590dcaa696aca4c55f260c99f94e51f4bf93def0edb4812f7c0963"
    sha256 cellar: :any_skip_relocation, monterey:       "c3570843ed590dcaa696aca4c55f260c99f94e51f4bf93def0edb4812f7c0963"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f9ef36cbe9bf56571aa896f557befe51c6ff9b6a39779068596a99604999c2d"
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