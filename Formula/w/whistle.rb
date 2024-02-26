require "languagenode"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https:github.comavwowhistle"
  url "https:registry.npmjs.orgwhistle-whistle-2.9.65.tgz"
  sha256 "a54bb007a05224969c9add41d6565206ea18b5896961a47765f8dc95857f865d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ad50bfe261408f6c7ca705814284916a9d63480f0d07b61849ec0032c2ce73b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad50bfe261408f6c7ca705814284916a9d63480f0d07b61849ec0032c2ce73b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad50bfe261408f6c7ca705814284916a9d63480f0d07b61849ec0032c2ce73b2"
    sha256 cellar: :any_skip_relocation, sonoma:         "e857e20ff41032fbab9f11a27b7057886b3ac4ae8efbabb266b1a1414b504570"
    sha256 cellar: :any_skip_relocation, ventura:        "e857e20ff41032fbab9f11a27b7057886b3ac4ae8efbabb266b1a1414b504570"
    sha256 cellar: :any_skip_relocation, monterey:       "e857e20ff41032fbab9f11a27b7057886b3ac4ae8efbabb266b1a1414b504570"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e857e20ff41032fbab9f11a27b7057886b3ac4ae8efbabb266b1a1414b504570"
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