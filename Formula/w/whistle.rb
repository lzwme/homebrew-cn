require "languagenode"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https:github.comavwowhistle"
  url "https:registry.npmjs.orgwhistle-whistle-2.9.62.tgz"
  sha256 "0648c8b532c901a552075fde751714837564ec6a5b556fff96285ff1ea03a70d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "238c2dbee6a3d4ea4dcc6515d923d68cb20fd69f21c14182d374dd1b064516e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "238c2dbee6a3d4ea4dcc6515d923d68cb20fd69f21c14182d374dd1b064516e1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "238c2dbee6a3d4ea4dcc6515d923d68cb20fd69f21c14182d374dd1b064516e1"
    sha256 cellar: :any_skip_relocation, sonoma:         "80daea0f54a3f02e6bc64eba8fbae57baac1518a45423b298534a47ba5b732d6"
    sha256 cellar: :any_skip_relocation, ventura:        "80daea0f54a3f02e6bc64eba8fbae57baac1518a45423b298534a47ba5b732d6"
    sha256 cellar: :any_skip_relocation, monterey:       "80daea0f54a3f02e6bc64eba8fbae57baac1518a45423b298534a47ba5b732d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80daea0f54a3f02e6bc64eba8fbae57baac1518a45423b298534a47ba5b732d6"
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