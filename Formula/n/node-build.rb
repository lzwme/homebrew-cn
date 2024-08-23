class NodeBuild < Formula
  desc "Install NodeJS versions"
  homepage "https://github.com/nodenv/node-build"
  url "https://github.com/nodenv/node-build/archive/refs/tags/v5.3.9.tar.gz"
  sha256 "ec32dc414ad5c1dde5fb5b501d76fe636f96be676383e50f8f0d9d02ecb9ee36"
  license "MIT"
  head "https://github.com/nodenv/node-build.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cbd58ee16919cc0462f24937f2d4217c2e87e76bc78e9abdd12fa7183b9e85ba"
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