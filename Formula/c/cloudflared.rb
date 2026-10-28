class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/"
  url "https://ghfast.top/https://github.com/cloudflare/cloudflared/archive/refs/tags/2026.10.5.tar.gz"
  sha256 "cca0918e869d6e303ab9d0a31bc1d96ae7dbbbfe6ff2bde9208159ea91f793d6"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "00a7d2d4b229246fadd7eb619d947c6db2eb4ce3e19fe8cb473bd418badc3b48"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0c0172ab975758f80d52f45cbda874d8c5be544f5662d5afd1a3f835dbdbf957"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b1ad11ab221ae43688cd50ad89ce82248f08ecd940653aa5fce916e1a08b4a9a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "10f57e2ab7a484109e82e4ddc05b5ae80803d5c87ed245d2e95b79609ce4527b"
    sha256 cellar: :any,                 x86_64_linux:      "3522b041b8d1f2245dc1866e955bb6571d9b494b2b891fedbf74dd1c7d720e4d"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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