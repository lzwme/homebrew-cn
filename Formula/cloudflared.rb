class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide"
  url "https://ghproxy.com/https://github.com/cloudflare/cloudflared/archive/refs/tags/2023.2.2.tar.gz"
  sha256 "b0abaff125d29c517894f6ea74dcc7044c92500670463595ba9ff4950a1d2fc2"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af7288ac0f76a8c9470b3b7e9a18dc2d0d514bfe07bb9ee8bbf5888138b93d56"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3878a8fb86ef682b3595a30f93ed16b4ab9c8d2bd5c5b1e887f61636279772f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "12a4defa1c4b01db0ee732c17da015f4457c5d20124656d79f3d3894bc41826c"
    sha256 cellar: :any_skip_relocation, ventura:        "1c62353e2644768842739e6ea84be8f088c78fe8965f349ec3895595919ea414"
    sha256 cellar: :any_skip_relocation, monterey:       "28d209bde1af2f864dceea9afb0f2bfc27323d6a1df12ead06db0f1668ac1de5"
    sha256 cellar: :any_skip_relocation, big_sur:        "f104f89aaf4ccd51b069d52dd61d2adf9d84d3a4b3b37e7cc8011d8820455ded"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fcfc3316a6408550488f683a84e45cb8301048f624fb71c61bca719960dd5ba0"
  end

  # https://github.com/cloudflare/cloudflared/issues/888
  depends_on "go@1.19" => :build

  def install
    system "make", "install",
      "VERSION=#{version}",
      "DATE=#{time.iso8601}",
      "PACKAGE_MANAGER=#{tap.user}",
      "PREFIX=#{prefix}"
  end

  test do
    help_output = shell_output("#{bin}/cloudflared help")
    assert_match "cloudflared - Cloudflare's command-line tool and agent", help_output
    assert_match version.to_s, help_output
    assert_equal "unable to find config file\n", shell_output("#{bin}/cloudflared 2>&1", 1)
    assert_match "Error locating origin cert", shell_output("#{bin}/cloudflared tunnel run abcd 2>&1", 1)
    assert_match "cloudflared was installed by #{tap.user}. Please update using the same method.",
      shell_output("#{bin}/cloudflared update 2>&1")
  end
end