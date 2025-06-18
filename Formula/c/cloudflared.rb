class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https:developers.cloudflare.comcloudflare-oneconnectionsconnect-appsinstall-and-setuptunnel-guide"
  url "https:github.comcloudflarecloudflaredarchiverefstags2025.6.1.tar.gz"
  sha256 "73b402abb8519b70a889eeb1c47c7c5fa58e0092e9859e4001ebb15e95b8043b"
  license "Apache-2.0"
  head "https:github.comcloudflarecloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6de43a56829effe87bc29e7f22377d06b1588a683f6184854bd01c4a46368a28"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ca7c0ab8b81862e409576523a30c24770cbfed872408bd8a532b08d750f3cf8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "97d8a7168080ce8679d411183981b4e952a834ee6120c3c3db9507fb82e290bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "7bd2458a54510a86db0e326ee533c8ba07b3714f97fb3f1f60c93f85a06bf8d8"
    sha256 cellar: :any_skip_relocation, ventura:       "b4600d7c96a9a02d0d1bef7a8fa9674f13651d307e128924f8e8627f7b46634d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "811c27cb9806152d410bbb252f65f7bdff9bcd006b8b9abb6594d2ed9b9dc6d1"
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