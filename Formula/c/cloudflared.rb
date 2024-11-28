class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https:developers.cloudflare.comcloudflare-oneconnectionsconnect-appsinstall-and-setuptunnel-guide"
  url "https:github.comcloudflarecloudflaredarchiverefstags2024.11.1.tar.gz"
  sha256 "1bf729c225701f6864b31bb6c251293caa06f9f1a6e671f3326dd20c3c9719ff"
  license "Apache-2.0"
  revision 1
  head "https:github.comcloudflarecloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07d4134b91fe1115235f0a3daae9f7393867ca82d1c01b705a9d685ea9805903"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77e61c7f0895ff962b5957e7ae43af78e83cf2d28f2825e1fa77f41e987c01af"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8640b280ea07699648d15f2567593d41935ffe2e459fff04a1d5e07b8aad0da8"
    sha256 cellar: :any_skip_relocation, sonoma:        "3bd28cfb6cc90e0c2ea3d5627f520b23c66d9deb7631d3a78fd16a31c7b18b61"
    sha256 cellar: :any_skip_relocation, ventura:       "bddb768669fa4d5c38a6665d2f395a301e4ee9281208994e319c23fdb0059d90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d896179cb61f7122542eb17df62ed7c82335d66de4d96f80a0c0474fda3ad130"
  end

  depends_on "go" => :build

  def install
    system "make", "install",
      "VERSION=#{version}",
      "DATE=#{time.iso8601}",
      "PACKAGE_MANAGER=#{tap.user}",
      "PREFIX=#{prefix}"
  end

  service do
    run [opt_bin"cloudflared"]
    keep_alive successful_exit: false
    log_path var"logcloudflared.log"
    error_log_path var"logcloudflared.log"
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