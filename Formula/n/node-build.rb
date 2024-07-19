class NodeBuild < Formula
  desc "Install NodeJS versions"
  homepage "https://github.com/nodenv/node-build"
  url "https://github.com/nodenv/node-build/archive/refs/tags/v5.3.5.tar.gz"
  sha256 "87a7943128fb68edcf7b0fab6b2153b4e456505bcb8ee65c8394e0721b36dc29"
  license "MIT"
  head "https://github.com/nodenv/node-build.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a3224289cedd5c872dc50df0808b8331bf2784bf7ba419050384cdc1da341183"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a3224289cedd5c872dc50df0808b8331bf2784bf7ba419050384cdc1da341183"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a3224289cedd5c872dc50df0808b8331bf2784bf7ba419050384cdc1da341183"
    sha256 cellar: :any_skip_relocation, sonoma:         "a3224289cedd5c872dc50df0808b8331bf2784bf7ba419050384cdc1da341183"
    sha256 cellar: :any_skip_relocation, ventura:        "a3224289cedd5c872dc50df0808b8331bf2784bf7ba419050384cdc1da341183"
    sha256 cellar: :any_skip_relocation, monterey:       "a3224289cedd5c872dc50df0808b8331bf2784bf7ba419050384cdc1da341183"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c91f6eafb923b45f83f4111dee64eb2e855c2348fa38aaf3fa58992457f381ce"
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