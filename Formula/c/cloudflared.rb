class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/"
  url "https://ghfast.top/https://github.com/cloudflare/cloudflared/archive/refs/tags/2025.10.1.tar.gz"
  sha256 "703424cd8e42090d52287502c4daa1f40d927a4eddd2e7dc3248da49ea2aa726"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2e2d016cd4996abee1390848ba7cb3f6bb1401d663351c8b53dded60468d58fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "14b33aee860607ee5c7fc835d0a9c512e6cacc9d995146e24bca0b27b76be9ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c6e5bc9a5bdb1ee0981ac4675f8abe30f9fce9a8ed6d115c408c88cfaaea952"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f4fc60e953405fb6eb612b482ecfa6b23d0a2ea4fd2fcdd4bff7629d31cb642"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "83141a476c3b75a2fece573f02ae5924db3541d7650ec48e836f395c4adf2b55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4aa1f02996d300b467d6abef7bd3ab590368fe5ba17af421e4f36ce9a4ae7d2c"
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