class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https:developers.cloudflare.comcloudflare-oneconnectionsconnect-appsinstall-and-setuptunnel-guide"
  url "https:github.comcloudflarecloudflaredarchiverefstags2025.6.0.tar.gz"
  sha256 "5d1dc902930bca96b4d97d7204f6472c53ae04f523f55f2803e8115c99310912"
  license "Apache-2.0"
  head "https:github.comcloudflarecloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "06d80d13b621c422ee6fd3c4b9b644df34f1b7de1aab8b50b7609a58826bb0fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06d80d13b621c422ee6fd3c4b9b644df34f1b7de1aab8b50b7609a58826bb0fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "06d80d13b621c422ee6fd3c4b9b644df34f1b7de1aab8b50b7609a58826bb0fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "b39d02ec9ff00ff5764bf902d7d1a3b7877c0a6321eab4e1ae46fb4f8390e123"
    sha256 cellar: :any_skip_relocation, ventura:       "b39d02ec9ff00ff5764bf902d7d1a3b7877c0a6321eab4e1ae46fb4f8390e123"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2af04d526409b6ca38f0703e5ce50cc657ec8fed5674b77ae90d9efcab20e202"
  end

  depends_on "go" => :build

  def install
    # We avoid using the `Makefile` to ensure usage of our own `go` toolchain.
    # Set `gobuildid` to create an LC_UUID load command.
    # This is needed to grant user permissions for local network access.
    ldflags = %W[
      -B gobuildid
      -X main.Version=#{version}
      -X main.BuildTime=#{time.iso8601}
      -X github.comcloudflarecloudflaredcmdcloudflaredupdater.BuiltForPackageManager=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdcloudflared"
    inreplace "cloudflared_man_template" do |s|
      s.gsub! "${DATE}", time.iso8601
      s.gsub! "${VERSION}", version.to_s
    end
    man1.install "cloudflared_man_template" => "cloudflared.1"
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

    return unless OS.mac?

    refute_empty shell_output("dwarfdump --uuid #{bin}cloudflared").chomp
  end
end