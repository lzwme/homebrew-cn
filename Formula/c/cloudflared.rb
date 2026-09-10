class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/"
  url "https://ghfast.top/https://github.com/cloudflare/cloudflared/archive/refs/tags/2026.9.0.tar.gz"
  sha256 "27e04a5d86f400b7d66a2a7638acb7efd41c219cff7b0bf40de3c6647d2514db"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c54c4bf397e480bbedc52c2c6438855865e5e1640bf8f2e1ff52dce33d01f153"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1647689bab55a8fc4116f393a41f6f30b15636a1d23c68838929c9f12c97b3a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c5437333d32457e8f59dfaab6e88dc222bcdd40a450178f36d7fac559a24473"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60f3f3c02c2e4ad7c7e40124f303909ded6e69d7c64e19979155e46f16bfd35f"
    sha256 cellar: :any,                 x86_64_linux:  "c0e0d981401587c1014aedb245ef7fa8ef533ae302ef2b0fa6efd47ffb26efab"
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