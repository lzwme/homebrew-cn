class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/"
  url "https://ghfast.top/https://github.com/cloudflare/cloudflared/archive/refs/tags/2026.1.0.tar.gz"
  sha256 "bbd3d8722ab4d7e16e2f206bb026de3ed004f1bb164abc010ad1ad5561f40cf5"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b3a797f237f56e179c6456dd19d4e50263218cf54ad2e27868feb1d8103a2503"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "400ef12e99b360f56f2cbddaa5c1ed2c12144170e53d2b246956695199d4714f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59581f8fa4ba6e5d62e1c2010c0df12808e695f2253913e3daff667bc9083446"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c563a2c9b5caefc12b5921318971795caf604adeb8d0487d7baa553b592c847"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a50b2b7685f4feafc77dd341e57b795a29b8622740fe37418d6b301229714d39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c797b5982bac8f1f1aaa4a047e3f93e581a9b6c6aff4d87473e117dfb03b99f3"
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