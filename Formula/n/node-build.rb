class NodeBuild < Formula
  desc "Install NodeJS versions"
  homepage "https://github.com/nodenv/node-build"
  url "https://github.com/nodenv/node-build/archive/refs/tags/v5.3.10.tar.gz"
  sha256 "758537e2995b9f271ecf1b5c00f6a6e9cd55f334ddcd6777bbb301a19435ebde"
  license "MIT"
  head "https://github.com/nodenv/node-build.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "908029e3e6e4856c315ec93421eea9a776eb93fc7cc303f53d877717ad91ad58"
  end

  depends_on "autoconf"
  depends_on "openssl@3"
  depends_on "pkg-config"

  def install
    ENV["PREFIX"] = prefix
    system "./install.sh"
  end

  test do
    system bin/"node-build", "--definitions"
  end
end