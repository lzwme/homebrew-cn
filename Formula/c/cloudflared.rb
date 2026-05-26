class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/"
  url "https://ghfast.top/https://github.com/cloudflare/cloudflared/archive/refs/tags/2026.5.1.tar.gz"
  sha256 "f5f68db015a65d49b3dd40e77630efbce47051baf017e23afae6e0411828ff1f"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6c9dccca70b2c45603318343a02f000dd74a792c11df1beb2a5b7e2246a2fb26"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d07601fbe94bd04733f884e98e1266018f899a6cbb165b545e6927ac1e2883e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95f25cb3a2d0e7a74610607db620b351497a80e68e6365a4527f8cbba034f74e"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9d33bd1331aad7b7e0cfccd762b5dbba034bb4818395265122423631c918757"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6136d0de018f4750e7d9eb9423d7549f80b513e76a421b01488c7148447a9614"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "272184d055feff6cc4cb34ac09351ffab250ac5502b626b276c37477aefb0728"
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