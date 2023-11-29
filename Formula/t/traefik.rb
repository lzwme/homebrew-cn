class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://ghproxy.com/https://github.com/traefik/traefik/releases/download/v2.10.6/traefik-v2.10.6.src.tar.gz"
  sha256 "1e2a8d03c99cfcfa47cc9759a99d6557f859d180fac40af64da7c09c9193f904"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ef1f3eac2703ef761242ef64fdc2d0f28e1cb019aa98240617e69f274001c10e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "77844a282bfe6f4e20fa1db026da91ce96ec0fef05ac12e7f0d964017a932c90"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "025cf22cd6c3b325ddd4ebbeb390f838ac2b16a79367712d7094b57613d6d821"
    sha256 cellar: :any_skip_relocation, sonoma:         "634a6c8b1cac4ebcb18892daff63a9fab70ed2f7f4a2b676f92f184fab62193b"
    sha256 cellar: :any_skip_relocation, ventura:        "56ca13db4b31058e51f2a411d68da5cdd8bf083174789b0d3e2426ba2d6ddab7"
    sha256 cellar: :any_skip_relocation, monterey:       "93c5ce9332b48ec9fbfe288e593759e7674ec4cb7da4a108b9402651f24ccb14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd53130eb10d15ed7a4a8e0cefc0abaefe495aea92471350b32a984938630e24"
  end

  depends_on "go" => :build

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