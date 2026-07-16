class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/"
  url "https://ghfast.top/https://github.com/cloudflare/cloudflared/archive/refs/tags/2026.7.2.tar.gz"
  sha256 "7c437dcf6c2b2efb25b93eaca4724f9be582d48fa97e020a11a177b36d14d606"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7d871bb7bd2113f95a900d211223c8236cabe4f90eccbbca1ea298dfa1af4a52"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "327dfce4936eaf00049cc2bd7282b9be5c1c7d518f2996f89a9fa19b95f8fc79"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15212dc4a6516b99f244708b1f195cf4ec6bb3c586f65ddcf673ec09d9dec225"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c149e94552bf739fb1cefb0db92c208d263ab0833550210b44450f582036eac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2453987b0141d934864e04ea72b5837e45714d7c5619e08399fb01bbc2f3467d"
    sha256 cellar: :any,                 x86_64_linux:  "3f9e00f355c1b1e48bafb79da18193a5ec144af7139d1b8146c1984475c8b8ca"
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