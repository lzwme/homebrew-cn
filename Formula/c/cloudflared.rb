class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/"
  url "https://ghfast.top/https://github.com/cloudflare/cloudflared/archive/refs/tags/2026.1.2.tar.gz"
  sha256 "5e6a8e81de61f180ddee8cfb1b58e4978729bfacd774affa343867dca6fa244f"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8c7fb75cd858597f685264adf484166ce5af8916ede4248c3004badd6c20385a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41f72dd49ceea980f72e7cc36a6596bd6804ad882a7760179a1a836650e4cfea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6cda06b44eef1e8b1dcd01300e3fdfc92e3a99eac68c95ce6fa1fb13ce0943b"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb55d1d1b1a1fb9da9d03633fd403b23cdb28596b658073c47054d9d5e9560bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45b2a901dde95bfbc35e163f70b6b9d8cc59d0d72f2b62b9aa699a4c6c22cdcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b4ad3dc69770d6c82a0121f87c9c53e8d749cf7986f6496ccfced3e8b3306e3"
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