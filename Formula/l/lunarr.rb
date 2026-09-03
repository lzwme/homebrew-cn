class Lunarr < Formula
  desc "Self-hosted media streaming server and Plex alternative for movies and TV"
  homepage "https://github.com/lunarr-app/lunarr-go"
  url "https://ghfast.top/https://github.com/lunarr-app/lunarr-go/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "b035633a2d8b98b171da2a2c59663ecf98faee2f630b78598afcedc45ec91464"
  license "Apache-2.0"
  head "https://github.com/lunarr-app/lunarr-go.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2e2c9b2ed181a3eeb4592289aa3e39b3883aee219bf2525a238b7f3826d4eb7f"
    sha256 cellar: :any, arm64_sequoia: "7efed3f6f965c3103848457bd0d6ab60681577a289ae33745287785900c5902a"
    sha256 cellar: :any, arm64_sonoma:  "5a1f25d296be9c2e79e2769bf1a6fdde5fa01b24466a6533e46dd8b65ee588e3"
    sha256 cellar: :any, arm64_linux:   "954b52651270479f8549ac96ae52338b454c1cf17b41020af0eb2eb18f0827f6"
    sha256 cellar: :any, x86_64_linux:  "1b376e643ead7a1523906c26192e68cd59b58df8308b8e597eb46a9855831912"
  end

  depends_on "ffmpeg"
  depends_on "node"

  def install
    system "npm", "install", *std_npm_args(prefix: false)
    system "npm", "run", "build"
    system "npm", "prune", "--omit=dev"

    # strip the foreign slice of the universal binary to satisfy `brew audit`
    deuniversalize_machos "node_modules/fsevents/fsevents.node" if OS.mac?

    # keep only the prebuilt native libraries matching this platform;
    # @libsql suffixes the libc (`darwin-arm64`, `linux-arm64-gnu`) while
    # @seydx/node-av prefixes the package name (`node-av-darwin-arm64`)
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    os_arch = OS.mac? ? "darwin-#{arch}" : "linux-#{arch}"
    Dir["node_modules/@{libsql,seydx}/*"].each do |dir|
      base = File.basename(dir)
      rm_r(dir) unless base.end_with?(os_arch, "#{os_arch}-gnu")
    end

    libexec.install Dir["*"]
    (bin/"lunarr").write_env_script formula_opt_bin("node")/"node", libexec/"scripts/start.mjs",
                                    NODE_ENV:    "production",
                                    FFMPEG_PATH: formula_opt_bin("ffmpeg")/"ffmpeg"
  end

  service do
    run [opt_bin/"lunarr"]
    keep_alive true
    environment_variables LUNARR_DATA_DIR: var/"lunarr"
    log_path var/"log/lunarr.log"
    error_log_path var/"log/lunarr.log"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/lunarr --version").strip

    port = free_port
    ENV["LUNARR_DATA_DIR"] = (testpath/"data").to_s
    ENV["PORT"] = port.to_s
    pid = spawn bin/"lunarr"
    begin
      output = shell_output("curl --silent --retry 10 --retry-connrefused --retry-delay 3 " \
                            "http://127.0.0.1:#{port}/api/health")
      assert_match "\"ok\":true", output
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end