class NodeBuild < Formula
  desc "Install NodeJS versions"
  homepage "https://github.com/nodenv/node-build"
  url "https://github.com/nodenv/node-build/archive/refs/tags/v5.4.62.tar.gz"
  sha256 "0dea570338692dd19daf47f87bc04e7eed4923a625ffa41ac26c2fb6141bd5dc"
  license "MIT"
  compatibility_version 1
  head "https://github.com/nodenv/node-build.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8c3c75039381c3c81023e17216742d676646424fcf3c41652e51a1f37e6bcc64"
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