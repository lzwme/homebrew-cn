class NodeBuild < Formula
  desc "Install NodeJS versions"
  homepage "https://github.com/nodenv/node-build"
  url "https://github.com/nodenv/node-build/archive/refs/tags/v4.9.146.tar.gz"
  sha256 "0eb30c618c171b688d4edcb42e4644ce8864d606ce7a0c07a2986af2b6761e36"
  license "MIT"
  head "https://github.com/nodenv/node-build.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a16c19ffddbaa680c07fdc47d0273880539844cba25f0972da5cce6726bab21f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f891fb03a077452e04e8386ce40020e804f7c40f541ee81074bf749be67e93b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eaf846378e9a4dc5e82eef54d7a85571986fb21c7ef0d986eb06fa4237fad954"
    sha256 cellar: :any_skip_relocation, sonoma:         "1566abfe22388ccfd67c21a5b4301ff0000877fc3d3ce2658d142fec89ed986e"
    sha256 cellar: :any_skip_relocation, ventura:        "da968e32127c15fa5efa0f397ef42c89c380d73423a0b30a9881114649e8dd52"
    sha256 cellar: :any_skip_relocation, monterey:       "0d7cb3a2daf7e4749b2273672aea7b1e0888e28b36954e12cca795c834318ec7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9982424886ac57b043a0c03e6e83bf9b3839727edebfab4f1dc8d814021512f0"
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