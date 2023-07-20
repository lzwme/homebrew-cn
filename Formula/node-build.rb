class NodeBuild < Formula
  desc "Install NodeJS versions"
  homepage "https://github.com/nodenv/node-build"
  url "https://github.com/nodenv/node-build/archive/v4.9.118.tar.gz"
  sha256 "31808e5703d1c18969036b54335b6266612c2df261b8548a88f8f63f32de94d0"
  license "MIT"
  head "https://github.com/nodenv/node-build.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8e6f701319fec1377b7b0058d1783eebf2a31a0a0c22ed7ae4fc54c5a461310f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e6f701319fec1377b7b0058d1783eebf2a31a0a0c22ed7ae4fc54c5a461310f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8e6f701319fec1377b7b0058d1783eebf2a31a0a0c22ed7ae4fc54c5a461310f"
    sha256 cellar: :any_skip_relocation, ventura:        "8e6f701319fec1377b7b0058d1783eebf2a31a0a0c22ed7ae4fc54c5a461310f"
    sha256 cellar: :any_skip_relocation, monterey:       "8e6f701319fec1377b7b0058d1783eebf2a31a0a0c22ed7ae4fc54c5a461310f"
    sha256 cellar: :any_skip_relocation, big_sur:        "8e6f701319fec1377b7b0058d1783eebf2a31a0a0c22ed7ae4fc54c5a461310f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "217aa45826134a682b6347e1fff900172d064b5a18c496d57aeebce71f844a46"
  end

  depends_on "autoconf"
  depends_on "openssl@3"
  depends_on "pkg-config"

  def install
    ENV["PREFIX"] = prefix
    system "./install.sh"
  end

  test do
    system "#{bin}/node-build", "--definitions"
  end
end