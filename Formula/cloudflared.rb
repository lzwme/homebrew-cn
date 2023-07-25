class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide"
  url "https://ghproxy.com/https://github.com/cloudflare/cloudflared/archive/refs/tags/2023.7.2.tar.gz"
  sha256 "1bcdb00d6899fd27d84f935bdd911ebb27b4dadbde98d261df97736ee5cc4f5f"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2cd849bf91398237666fd03055426e5f9ab807ed9272391316dc825d89696140"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d71ca649fc2c56fd31209b9838841f9d26ec835d2ec54dcf8763eb875394a9f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "626bf7cc1aeac3fdc4d01ee652db1c3204868c66affc460412e0cea3ecf9c89c"
    sha256 cellar: :any_skip_relocation, ventura:        "e314089b7b65fb43758b9dcb558fd37915cd64b7c4a44680658162671a87777f"
    sha256 cellar: :any_skip_relocation, monterey:       "23f72e510d262656050c4f911b6f16e874c0e2aa41a5612aea14d7ac1717974c"
    sha256 cellar: :any_skip_relocation, big_sur:        "aabfc68ac0266cda092d6db42c794d3a6157b6fe898a8fefd06e3f6affd08eb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b521e167b687bb63ecc7bcbf16968853855fe37c5e585276151fd84cecdb884e"
  end

  depends_on "go" => :build

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