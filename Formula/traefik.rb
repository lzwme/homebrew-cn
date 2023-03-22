class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://ghproxy.com/https://github.com/traefik/traefik/releases/download/v2.9.9/traefik-v2.9.9.src.tar.gz"
  sha256 "3f0587ade4aae67c8e52ee3d499e0e908d50e4c9751d9850f02054fb7c352c45"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a0af0577dce4fe75fdfef0d2fee7276eaf30e449e287a7d8efc115e9f013119"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a0af0577dce4fe75fdfef0d2fee7276eaf30e449e287a7d8efc115e9f013119"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4a0af0577dce4fe75fdfef0d2fee7276eaf30e449e287a7d8efc115e9f013119"
    sha256 cellar: :any_skip_relocation, ventura:        "ffacabb4075208d5a08ec2be49903f5c165c6513d712c13a9c34ee15e29b2030"
    sha256 cellar: :any_skip_relocation, monterey:       "062078929090b603c0e86639a8f3bdd20066449a93c773d4d6a3471fb586a19b"
    sha256 cellar: :any_skip_relocation, big_sur:        "15aeeb8516ad1e38e2ac8834941e278ce3b6985f4852a71e83fc0fa6697bc631"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a1ca17f8595c9d44ae686b8ed8d766aed0c39894e6d11d233bec232035f03a4"
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/traefik/traefik/v#{version.major}/pkg/version.Version=#{version}
    ].join(" ")
    system "go", "generate"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/traefik"
  end

  service do
    run [opt_bin/"traefik", "--configfile=#{etc}/traefik/traefik.toml"]
    keep_alive false
    working_dir var
    log_path var/"log/traefik.log"
    error_log_path var/"log/traefik.log"
  end

  test do
    ui_port = free_port
    http_port = free_port

    (testpath/"traefik.toml").write <<~EOS
      [entryPoints]
        [entryPoints.http]
          address = ":#{http_port}"
        [entryPoints.traefik]
          address = ":#{ui_port}"
      [api]
        insecure = true
        dashboard = true
    EOS

    begin
      pid = fork do
        exec bin/"traefik", "--configfile=#{testpath}/traefik.toml"
      end
      sleep 5
      cmd_ui = "curl -sIm3 -XGET http://127.0.0.1:#{http_port}/"
      assert_match "404 Not Found", shell_output(cmd_ui)
      sleep 1
      cmd_ui = "curl -sIm3 -XGET http://127.0.0.1:#{ui_port}/dashboard/"
      assert_match "200 OK", shell_output(cmd_ui)
    ensure
      Process.kill(9, pid)
      Process.wait(pid)
    end

    assert_match version.to_s, shell_output("#{bin}/traefik version 2>&1")
  end
end