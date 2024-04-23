require "languagenode"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https:github.comavwowhistle"
  url "https:registry.npmjs.orgwhistle-whistle-2.9.69.tgz"
  sha256 "ebece1ee4a5431b1bb3856ecef79ee13e6b2cf5cb487af3815f961ed5f326d8f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d4a05e335c0a2a72ba58a0d515a306b4b6f43cbf38d3b70b27171b3b73cedd74"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d4a05e335c0a2a72ba58a0d515a306b4b6f43cbf38d3b70b27171b3b73cedd74"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d4a05e335c0a2a72ba58a0d515a306b4b6f43cbf38d3b70b27171b3b73cedd74"
    sha256 cellar: :any_skip_relocation, sonoma:         "3f226e49c54dad5e22bf40fab153d9cc8e5498351e6e39050c3702ab0e50f91a"
    sha256 cellar: :any_skip_relocation, ventura:        "3f226e49c54dad5e22bf40fab153d9cc8e5498351e6e39050c3702ab0e50f91a"
    sha256 cellar: :any_skip_relocation, monterey:       "3f226e49c54dad5e22bf40fab153d9cc8e5498351e6e39050c3702ab0e50f91a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f226e49c54dad5e22bf40fab153d9cc8e5498351e6e39050c3702ab0e50f91a"
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