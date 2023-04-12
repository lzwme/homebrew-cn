class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide"
  url "https://ghproxy.com/https://github.com/cloudflare/cloudflared/archive/refs/tags/2023.4.0.tar.gz"
  sha256 "bdb9dea9e5f9bb6b66878bbd1243d8a57fc565ca946c5f9790c2f120400ffa9e"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8297a985fe94f85898363a3e5ed2111d2d4caf5180737de8ef1846253bc96692"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5548009aae379b9ea8a3d12e5e7c645a7174fca78868ee669eaeed3b95aa8f10"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3b407b5e91d9fec6350dba4f04aae5c70a091f70eda1bf8564db5d9e6c04f65a"
    sha256 cellar: :any_skip_relocation, ventura:        "0f11c883ecd0ddd06c39f432c60b1f83df10041ade915f7f4b7cbf973822dba0"
    sha256 cellar: :any_skip_relocation, monterey:       "6536e0b9081ac610fc7ce14a24a2c83e2976e941504e47096481e30658af8eea"
    sha256 cellar: :any_skip_relocation, big_sur:        "c2264192ede80f2ad2f9c42bed53be9fee115a794e51a1c46dc50889718ab730"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15f1d360a59a061b34dc88b82e36b4242b4fc432cc1711a4f8b9be978779126c"
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