class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide"
  url "https://ghfast.top/https://github.com/cloudflare/cloudflared/archive/refs/tags/2025.10.0.tar.gz"
  sha256 "eeb5089874f21b7239de13565e01a752ff0f26a5543381c54ae3ffada99eaa17"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fafe253f5282794d816d240258674f891ab4981339843fbc0c3a389431c33bb2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e21a2461df1649a3015474235faec461973a4d62aed5c8e9b2d840dd6871f37"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4002ec1df05cfeb67e79bf4dfeef0bad4ae3043ff2b83cacd722e14cab8efaf6"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a08e090fe9c61460b47b30d249b2f8cf08c852b38226f0df617b2ba08152f2f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a50417d5e0a40f03c558030c2c5fdf9fa3ec7bddcdbda767aa3875e5750eea2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e117f7f580d66ce14d6133b80a5ae1bc2daf824ae467eed2b008c03ebb0e674"
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