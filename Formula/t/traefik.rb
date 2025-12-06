class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://ghfast.top/https://github.com/traefik/traefik/releases/download/v3.6.4/traefik-v3.6.4.src.tar.gz"
  sha256 "6c3039fa8f79b5ef77e8f3b5f94fd566a6e7a33f4783e346aeab6368b82605af"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "64e2c993ec6c424ad279d98119a947203f872bc0b0b984141a155d9bd8cd9a24"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4b558c2f4cd5c26dc7204def4d00ed4acb946e4890fffb77e34d75a4262b121"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97d5eae4e107a2fdb4f2b10202cd47874f99950008f87d096f1dd50a1b48033d"
    sha256 cellar: :any_skip_relocation, sonoma:        "c94135ab7e1f04416cfb4a2663f6652ef568693383379c1da69641dd817b8172"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2abce5ab4fe070d0f25e0658d2994ecd0045d54bda1a2057a7c6423464829a23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b498cf8c1d00188b03345e4805fd08bb4c593c8d289841696e52b4d36a730ae8"
  end

  depends_on "corepack" => :build
  depends_on "go" => :build
  depends_on "node" => :build

  def install
    ENV["COREPACK_ENABLE_DOWNLOAD_PROMPT"] = "0"

    system "corepack", "enable", "--install-directory", buildpath

    cd "webui" do
      system buildpath/"yarn", "install"
      system buildpath/"yarn", "build"
    end

    ldflags = %W[
      -s -w
      -X github.com/traefik/traefik/v#{version.major}/pkg/version.Version=#{version}
    ]
    system "go", "generate"
    system "go", "build", *std_go_args(ldflags:), "./cmd/traefik"
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

    (testpath/"traefik.toml").write <<~TOML
      [entryPoints]
        [entryPoints.http]
          address = ":#{http_port}"
        [entryPoints.traefik]
          address = ":#{ui_port}"
      [api]
        insecure = true
        dashboard = true
    TOML

    begin
      pid = fork do
        exec bin/"traefik", "--configfile=#{testpath}/traefik.toml"
      end
      sleep 8
      cmd_ui = "curl -sIm3 -XGET http://127.0.0.1:#{http_port}/"
      assert_match "404 Not Found", shell_output(cmd_ui)
      sleep 1
      cmd_ui = "curl -sIm3 -XGET http://127.0.0.1:#{ui_port}/dashboard/"
      assert_match "200 OK", shell_output(cmd_ui)

      # Make sure webui assets for dashboard are present at expected destination
      cmd_ui = "curl -XGET http://127.0.0.1:#{ui_port}/dashboard/"
      assert_match "<title>Traefik Proxy</title>", shell_output(cmd_ui)
    ensure
      Process.kill(9, pid)
      Process.wait(pid)
    end

    assert_match version.to_s, shell_output("#{bin}/traefik version 2>&1")
  end
end