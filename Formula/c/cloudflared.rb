class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/"
  url "https://ghfast.top/https://github.com/cloudflare/cloudflared/archive/refs/tags/2026.9.3.tar.gz"
  sha256 "f247f358f4dcc54d83a717be25b337f3e87ab4033e95e703b2d7e576bd534fef"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ee017b345659c3622e55f9cce2ec12b7f02b826950cf3c1383ba1f7116a37d98"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8cbe6f44149ce9c9e857d7fe39cfdc284d27db21d9b5b830511655402b3b26c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9de300533557d91fea5d0234520ab1d0ba992e791d0365a83152a56ec150206c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4a218b0acd851d7a5e31e38728bb1ee9699c8f6ca6ef217a8cd84438f9b1a3da"
    sha256 cellar: :any,                 x86_64_linux:      "ccfacdc5e161aa7c084713482571e930d14f71e8ce2749c3c043676b472477d0"
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