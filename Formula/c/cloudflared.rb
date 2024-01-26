class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https:developers.cloudflare.comcloudflare-oneconnectionsconnect-appsinstall-and-setuptunnel-guide"
  url "https:github.comcloudflarecloudflaredarchiverefstags2024.1.5.tar.gz"
  sha256 "0a0da188e162680927ebafcef32c3366aed26661273dc63c540bbebee435bd4e"
  license "Apache-2.0"
  head "https:github.comcloudflarecloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5a1203b7064087044af2a67538170a4a306b26d87b29da603dfeb53113f47777"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "15266570ea52a0a3cb9a128b68ddeb6594883071f9ec23e1142752b789ab9b84"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5a762a65450e6169ef6682304ab7de748889a59edc22e49663091eb871c0122"
    sha256 cellar: :any_skip_relocation, sonoma:         "ffac063a5c36ef200aebc2cb0b9b9e8c7d0ccdc3cb1ba4323bcc7aef8b8073d2"
    sha256 cellar: :any_skip_relocation, ventura:        "deccbe7fdccfa59fc34ee76fba13399bd30b153ffd963cc5ac1d2914e9e5eae8"
    sha256 cellar: :any_skip_relocation, monterey:       "e463af92b5a81a896e1395844785c632be73e2118a6a02976fd523af4786f502"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53b1c45ed00c6e4df63abbfaae21b4b07ca2dbd95b1bf72812b9cc9bcc122599"
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