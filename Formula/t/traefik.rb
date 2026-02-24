class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://ghfast.top/https://github.com/traefik/traefik/releases/download/v3.6.9/traefik-v3.6.9.src.tar.gz"
  sha256 "dd040144d2c5117de1572f7660904b810b5fa5c8182ad4ad1a884d9b0bda343d"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d7d130c1b2e615034985a1392219541cdde3f5fe941842dd5f96c07bf42484b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "244c98b775fe63ce34cea7c203cbef66323ed35f2083a0ad9a44b24c4693ded6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56febfd4cb5040ce25ede5886e0801e7d987f43c7f9db3308471278a4ef78a62"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae146e34767ee51f56d8279cd5379fefc5457f14e9eff6a0be1c5c02079be4f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae86f5d76bec9267b8e398faad4c335d2b3e9d7524cc1a42d566d92562f116cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39d474f0b47e2476a4b3b474eadf40520469609fdb9f5c4875d38a4fb2979171"
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