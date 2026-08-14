class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/"
  url "https://ghfast.top/https://github.com/cloudflare/cloudflared/archive/refs/tags/2026.8.1.tar.gz"
  sha256 "59d7dd479c121c03c49597f158a15582a6881c310b57f73e05b76f4b28566735"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e72c2afac8e2def45d1b1a36ca6d07485793ce7512cf48d5c91587c2cb43405f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56b75b18a9dec2cbe69b0ce80f2159ceefb1347ed14733273fb52070aa86796e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2278ca1bd22c64c5678cf82d572556c6ad7401e753ac2e727b934bd233992b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "583695ebcb258a97de68a376d05bbffe78837f265b9536ae1fd626be12dbc308"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52cd01568c6addc00e61bf360685a37c788652c06bc84d8bc7d2565f83ff3914"
    sha256 cellar: :any,                 x86_64_linux:  "5f4d1a383965bef7333dcb6316c9dd8822fb71547bc384aff1440feccc3ac34c"
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
      -X github.com/cloudflare/cloudflared/cmd/cloudflared/updater.BuiltForPackageManager=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cloudflared"
    inreplace "cloudflared_man_template" do |s|
      s.gsub! "${DATE}", time.iso8601
      s.gsub! "${VERSION}", version.to_s
    end
    man1.install "cloudflared_man_template" => "cloudflared.1"
  end

  service do
    run [opt_bin/"cloudflared"]
    keep_alive successful_exit: false
    log_path var/"log/cloudflared.log"
    error_log_path var/"log/cloudflared.log"
  end

  test do
    help_output = shell_output("#{bin}/cloudflared help")
    assert_match "cloudflared - Cloudflare's command-line tool and agent", help_output
    assert_match version.to_s, help_output
    assert_equal "unable to find config file\n", shell_output("#{bin}/cloudflared 2>&1", 1)
    assert_match "Error locating origin cert", shell_output("#{bin}/cloudflared tunnel run abcd 2>&1", 1)
    assert_match "cloudflared was installed by #{tap.user}. Please update using the same method.",
      shell_output("#{bin}/cloudflared update 2>&1")

    return unless OS.mac?

    refute_empty shell_output("dwarfdump --uuid #{bin}/cloudflared").chomp
  end
end