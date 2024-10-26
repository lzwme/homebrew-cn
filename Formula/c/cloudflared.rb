class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https:developers.cloudflare.comcloudflare-oneconnectionsconnect-appsinstall-and-setuptunnel-guide"
  url "https:github.comcloudflarecloudflaredarchiverefstags2024.10.1.tar.gz"
  sha256 "7e35e3e57a65f8914c5b53896cfa3711153af78b95d971791602c6624d53a1e1"
  license "Apache-2.0"
  head "https:github.comcloudflarecloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6d75ec2019f646e0d5b2a1027cc1bdf6324ec2711f906e279d9dc8ea0d947c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d612a9183ea21546b7108e601132d75bb445cf998d06923c358ac05bee5d2151"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0c9cade4d26e8a855c0c105b9638f3cf2ea46fa64eb0f883290f340009b51c60"
    sha256 cellar: :any_skip_relocation, sonoma:        "70df7282156045503fae95f49539552f1a4ba33afd5c03fa54965c6cadf7491c"
    sha256 cellar: :any_skip_relocation, ventura:       "5366f7fc48c1fc4efd50a609d7d3c6424486fa219487a2de8aefd20f9fb4c2f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3b20dc710657912943a825b97ff60aada10ac1f73dfd88a77f5d86173cc1a7f"
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
    help_output = shell_output("#{bin}cloudflared help")
    assert_match "cloudflared - Cloudflare's command-line tool and agent", help_output
    assert_match version.to_s, help_output
    assert_equal "unable to find config file\n", shell_output("#{bin}cloudflared 2>&1", 1)
    assert_match "Error locating origin cert", shell_output("#{bin}cloudflared tunnel run abcd 2>&1", 1)
    assert_match "cloudflared was installed by #{tap.user}. Please update using the same method.",
      shell_output("#{bin}cloudflared update 2>&1")
  end
end