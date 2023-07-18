class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide"
  url "https://ghproxy.com/https://github.com/cloudflare/cloudflared/archive/refs/tags/2023.7.1.tar.gz"
  sha256 "0863eadade6c6ac5838510d8fb514ec2332bb79bf54edc34e90cc79652b6c816"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bcedee7a1f9b98ad7a5a16ecc1241bcaf8be0c531c943a340898f02bd2c2a28c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b0f9b5bfd761dd0f58a4233c7f3c51787058032d881f6d15e62102cdb3fffc92"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7a223878e238fdcfe6c2a68557528da107e80ffc28b70fa67e8f53c983540060"
    sha256 cellar: :any_skip_relocation, ventura:        "ca4b15495497fb1001d4d79bab8aa3021b1fc8146cf56ab420916bdabbae892a"
    sha256 cellar: :any_skip_relocation, monterey:       "5240963cc6b2406b2d24ed14ddf31a45979529a7ddcbbea0876e207d97378bd7"
    sha256 cellar: :any_skip_relocation, big_sur:        "ddb912cec15b28bf0322959e1c72d3c783ec295187470f73049b750a9a5199f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d20b1f99495ed99fe62f45663333b493ce2b5adc3e84521abf1eacadb90ad27"
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