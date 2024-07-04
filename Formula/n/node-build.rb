class NodeBuild < Formula
  desc "Install NodeJS versions"
  homepage "https://github.com/nodenv/node-build"
  url "https://github.com/nodenv/node-build/archive/refs/tags/v5.3.3.tar.gz"
  sha256 "1620daa28aef89e2a44884642de7522f34496b21b0454d29e38280b06bea7a73"
  license "MIT"
  head "https://github.com/nodenv/node-build.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b44b76ad5a60d6a8bffb142fc89912914ed9b0fc23316b7f4275c89c766b7326"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b44b76ad5a60d6a8bffb142fc89912914ed9b0fc23316b7f4275c89c766b7326"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b44b76ad5a60d6a8bffb142fc89912914ed9b0fc23316b7f4275c89c766b7326"
    sha256 cellar: :any_skip_relocation, sonoma:         "b44b76ad5a60d6a8bffb142fc89912914ed9b0fc23316b7f4275c89c766b7326"
    sha256 cellar: :any_skip_relocation, ventura:        "b44b76ad5a60d6a8bffb142fc89912914ed9b0fc23316b7f4275c89c766b7326"
    sha256 cellar: :any_skip_relocation, monterey:       "b44b76ad5a60d6a8bffb142fc89912914ed9b0fc23316b7f4275c89c766b7326"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fdb088d5ea063db29ff165f3ee4b5a073844597ff6ddb79d1df5a9051482afac"
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