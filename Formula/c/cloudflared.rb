class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/"
  url "https://ghfast.top/https://github.com/cloudflare/cloudflared/archive/refs/tags/2026.6.0.tar.gz"
  sha256 "e79d48a3da4ab5ef9dd46c18730fc31e67c17934394ea7f1cbcf6f2c57e4d97f"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ab92daa19c39568a5547baf94cb44aed927533d22d214cb69c628776554a6a59"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6852cf2aefa7bdc2e36c39c23616587b35880a752ac36bc9e3bf8ccf24289d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a179524f524334f133afb287b3007ad94293c0832398be4d4110d4518fbc33c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "99db64ef6c27c204f2db5d7662177d952de404e48b839f20be4200f33209d9e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08ddacfe7e4d23df5cf627633d4f1f4fb68076b718cbf70be9023d4790ce8598"
    sha256 cellar: :any,                 x86_64_linux:  "0a3143d7c6a15f76dc21cc191ff0e4e27610bd3f5940e31d0ff8b340880b6ed3"
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