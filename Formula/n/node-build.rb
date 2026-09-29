class NodeBuild < Formula
  desc "Install NodeJS versions"
  homepage "https://github.com/nodenv/node-build"
  url "https://github.com/nodenv/node-build/archive/refs/tags/v5.4.56.tar.gz"
  sha256 "23ee5f1fb900437ac14d3f7012de861dc5ba86ccddb45526315a70dea5933f72"
  license "MIT"
  revision 1
  compatibility_version 1
  head "https://github.com/nodenv/node-build.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0965b94e84c1cf0aa0660dfbd0a34fa4cd2a15a98b4fd34927b60f7edba30fd9"
  end

  depends_on "autoconf"
  depends_on "openssl@4"
  depends_on "pkgconf"

  def install
    ENV["PREFIX"] = prefix
    system "./install.sh"
  end

  test do
    system bin/"node-build", "--definitions"
  end
end