class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide"
  url "https://ghfast.top/https://github.com/cloudflare/cloudflared/archive/refs/tags/2025.8.0.tar.gz"
  sha256 "a57411cdfc729b9f867ff42e4c365eeb31d0fdc5f763f7d813adf6f44a37ef35"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35019c939e7377d196b84ec751a64b47aa2c46326674b2e22e106a54e55c0149"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8f3216b23aaa1b4869f76df217d5e2da8378682f7dc062e91d768221784a97d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6261f9cd482be7d6234f098ccf962bc90441e0227a317bd23a5cb6f29d9e9fee"
    sha256 cellar: :any_skip_relocation, sonoma:        "c829733ae12760eb999a28872f8330ea1b6aa8f3f3a1fb5339eadc027d36d5ea"
    sha256 cellar: :any_skip_relocation, ventura:       "92d5fea2f5948771f541502360691d5cd49ba7ce8ad53f35a13bb64297fc97ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48bbbb57c4a5e9c27b69dd2c01d48efc80128fc90af57839b14b5df34bf33650"
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