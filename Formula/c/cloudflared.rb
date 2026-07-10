class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/"
  url "https://ghfast.top/https://github.com/cloudflare/cloudflared/archive/refs/tags/2026.7.1.tar.gz"
  sha256 "b47f3b4453a3a59317e6cc14e16e04a6f6d3cebe5447d3a245b09a78dba27a7a"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "08ae1a9e7bea55956a7fc2f1fcd36156eca396c89023ff96dcb44df3acd2b123"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f497b55148f97acfb70c04694f826e1310ebcb8711de31c2b6f44622ef344fa3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1571a4ce7ac62dfa37a53d55858e743ca08d092d5af15f2e6bdc4bb415bf2fe5"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a31419526deebb6a749532ae55d7c44a540c38045c6a9318ffec7da4e7b8b6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "564e9eb75a51e62221be90d1dedb032aeb43532f507b0873bf7432c46de8b6f9"
    sha256 cellar: :any,                 x86_64_linux:  "1faf710d3032c9e267c6ca95619234117d52c2eac76dceb866b5dd17a087942c"
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