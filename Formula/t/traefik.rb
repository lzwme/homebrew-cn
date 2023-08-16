class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://ghproxy.com/https://github.com/traefik/traefik/releases/download/v2.10.4/traefik-v2.10.4.src.tar.gz"
  sha256 "d47d61d1a240c4502a8a467987394f10ebf97554be2a93534df3eba3e32d5788"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b99c383994f55a141e6694bcb64192b64d67a921327ad2596d2332a17fe5ddd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b99c383994f55a141e6694bcb64192b64d67a921327ad2596d2332a17fe5ddd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6b99c383994f55a141e6694bcb64192b64d67a921327ad2596d2332a17fe5ddd"
    sha256 cellar: :any_skip_relocation, ventura:        "d84b466de767b17a03e75db7f64ae3964232346b4b818f8d42b2da8be5f0e325"
    sha256 cellar: :any_skip_relocation, monterey:       "84cd2ebc39550ff3d0307676e5045a9b005665095a589623cb8bc5ebf77abf50"
    sha256 cellar: :any_skip_relocation, big_sur:        "f0cabd8e7acd22ca82fc7be8be6eddca72c3f46e1f85afde7b0199788e3dbecb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a8e7592fcf1d1fa12266d85e7966ef2ec36bab6566e107db365e87920aa735d"
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