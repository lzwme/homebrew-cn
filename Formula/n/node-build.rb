class NodeBuild < Formula
  desc "Install NodeJS versions"
  homepage "https://github.com/nodenv/node-build"
  url "https://github.com/nodenv/node-build/archive/refs/tags/v4.9.149.tar.gz"
  sha256 "7ff2fdc0bec1c980cff0be3c6ad653b483ca8382addc5d6d74fcda9a7c36e765"
  license "MIT"
  head "https://github.com/nodenv/node-build.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bd2cd578f1dfe2d1ad72928b9383753330cf9011ff9c1d6b36f8a2a1ce10cef6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "29ad471eeb3c64cac99158e28fe582fded1ffa85bf8857ff5a74a66dc45a70e2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "28ca43cd3df0c10874468d624b228a94b05195e892d5d4f62f78cb7e177278ef"
    sha256 cellar: :any_skip_relocation, sonoma:         "cf85a738fc838683239bc27aeb878dcf65bbe974df317b42863f02326d7f8e29"
    sha256 cellar: :any_skip_relocation, ventura:        "e5495a582eea977b478d7d70a8c405cb0b4a9ee03f98426fc35db44e2299abb2"
    sha256 cellar: :any_skip_relocation, monterey:       "188843ce29dca4bd7605b1caa81f6aab99b127decbc816ecb3a019d26a25f29c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af7531da4c320bf88afb9ef3f1035e59546b773becf9920a3009b8699292c4e3"
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