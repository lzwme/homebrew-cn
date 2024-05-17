class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https:developers.cloudflare.comcloudflare-oneconnectionsconnect-appsinstall-and-setuptunnel-guide"
  url "https:github.comcloudflarecloudflaredarchiverefstags2024.5.0.tar.gz"
  sha256 "bb370747765ef059c236b577604a7fd0907a684333568e5765687d94ed1f2520"
  license "Apache-2.0"
  head "https:github.comcloudflarecloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3d626651c0d49e6f69cbd0adb924e0797173136c912eb11e6ca5c47f01d1cb3f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa4a1a1a8a203e8ada3012f2f81af4beb9d5daef767afa911a2b3b2db4b81896"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf05feeb7430b0d91734e34381237eb19d995bc1d827f0ebfb4095ab592d5d59"
    sha256 cellar: :any_skip_relocation, sonoma:         "ae950c15a71b5d1d4ea68855105ff2173adb62a5818805703fcf652d5c9f972b"
    sha256 cellar: :any_skip_relocation, ventura:        "7120d3b9b3aefd544903fa3e6ef46780b3df8a373cecd2c992b9f88360632a9e"
    sha256 cellar: :any_skip_relocation, monterey:       "f81516a15020268e74861463c13687e8b46d5135f946f78e8977011f36c182ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "669f0b7efa7549cc247e012c6f8caf3d7e578f446c04bec8bcae8f7883606459"
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