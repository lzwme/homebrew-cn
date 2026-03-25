class Autobrr < Formula
  desc "Modern, easy to use download automation for torrents and usenet"
  homepage "https://autobrr.com/"
  url "https://ghfast.top/https://github.com/autobrr/autobrr/archive/refs/tags/v1.75.1.tar.gz"
  sha256 "288b1667d503f118698841a64aa9a0f8ef2e81a4c9600878dfb9bea803402a02"
  license "GPL-2.0-or-later"
  head "https://github.com/autobrr/autobrr.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e0708542030d9e8efd5d3acb46e2a08c05d9348851b83148d5f7607b001bb808"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab881479abdeba98278f48192d0071bba7fc99dad99dac3ced1e562a61babc7d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7fcdc7fd8afcda79a1c1635034360e556ca78811c5b942cbff3d9a2731c0415f"
    sha256 cellar: :any_skip_relocation, sonoma:        "a67875dec3942733d67e237bbcbfc3226785327826e6187b223c098c2abccf3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f4b7a07c98a5e212b6c55161cae1fe2b6370f83dafc233b85d095b4c834d920"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19d1bc11d4d8613c4038cf5381bfb67592957611fd6f09e0a987ad8bff5ac7c4"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "pnpm", "install", "--dir", "web"
    system "pnpm", "--dir", "web", "run", "build"

    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"

    system "go", "build", *std_go_args(output: bin/"autobrr", ldflags:), "./cmd/autobrr"
    system "go", "build", *std_go_args(output: bin/"autobrrctl", ldflags:), "./cmd/autobrrctl"

    (var/"autobrr").mkpath
  end

  service do
    run [opt_bin/"autobrr", "--config", var/"autobrr/"]
    keep_alive true
    log_path var/"log/autobrr.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/autobrrctl version")

    port = free_port

    (testpath/"config.toml").write <<~TOML
      host = "127.0.0.1"
      port = #{port}
      logLevel = "INFO"
      checkForUpdates = false
      sessionSecret = "secret-session-key"
    TOML

    pid = spawn bin/"autobrr", "--config", testpath/""
    begin
      sleep 4
      system "curl", "-s", "--fail", "http://127.0.0.1:#{port}/api/healthz/liveness"
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end