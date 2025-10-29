class NodeBuild < Formula
  desc "Install NodeJS versions"
  homepage "https://github.com/nodenv/node-build"
  url "https://github.com/nodenv/node-build/archive/refs/tags/v5.4.17.tar.gz"
  sha256 "63c57161481b7d39bf1005a5209e620483891ab1b07170d0097a5554b023d069"
  license "MIT"
  head "https://github.com/nodenv/node-build.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c37c0d80792bf8d20607866500cf99ea73dea8d6a4ab2d6f6eef29a9b8f019ae"
  end

  depends_on "autoconf"
  depends_on "openssl@3"
  depends_on "pkgconf"

  def install
    ENV["PREFIX"] = prefix
    system "./install.sh"
  end

  test do
    system bin/"node-build", "--definitions"
  end
end