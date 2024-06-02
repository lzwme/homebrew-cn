class NodeBuild < Formula
  desc "Install NodeJS versions"
  homepage "https://github.com/nodenv/node-build"
  url "https://github.com/nodenv/node-build/archive/refs/tags/v5.1.0.tar.gz"
  sha256 "701fa9c5af7affd792920c5a6d7fcc833292570c6934687a946990a283646ace"
  license "MIT"
  head "https://github.com/nodenv/node-build.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "302cd91e4e5e625e2ba3ca64a3416e835e8eebb56b78d6ec645391be69707258"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "302cd91e4e5e625e2ba3ca64a3416e835e8eebb56b78d6ec645391be69707258"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "302cd91e4e5e625e2ba3ca64a3416e835e8eebb56b78d6ec645391be69707258"
    sha256 cellar: :any_skip_relocation, sonoma:         "302cd91e4e5e625e2ba3ca64a3416e835e8eebb56b78d6ec645391be69707258"
    sha256 cellar: :any_skip_relocation, ventura:        "302cd91e4e5e625e2ba3ca64a3416e835e8eebb56b78d6ec645391be69707258"
    sha256 cellar: :any_skip_relocation, monterey:       "302cd91e4e5e625e2ba3ca64a3416e835e8eebb56b78d6ec645391be69707258"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82e3038907afb672c20058ef4c3afddc59b044d185ca9bd28e0137b8dd0b9b67"
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