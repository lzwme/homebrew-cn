class Lunarr < Formula
  desc "Self-hosted media streaming server and Plex alternative for movies and TV"
  homepage "https://github.com/lunarr-app/lunarr-go"
  url "https://ghfast.top/https://github.com/lunarr-app/lunarr-go/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "dfd57c54d031c03a9396266b57d87bfcf9210220692432f0f3a34739b545c485"
  license "Apache-2.0"
  head "https://github.com/lunarr-app/lunarr-go.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "16c6f8ca6abbb7f9625d5635560bfc727e369f331228efe7ae29b8a4297b074a"
    sha256 cellar: :any,                 arm64_sequoia: "a7f0060fb14642b172ba669c4b2e5327193a6b5801355161f5eda00f53d4ded3"
    sha256 cellar: :any,                 arm64_sonoma:  "8e7220f2ba18c5f687f6fa13da8a5633f7f933744f4b2be4691ecaa5dddbeb60"
    sha256 cellar: :any,                 sonoma:        "f9b029d86e77c98755429375b357c0a1e32b4264718fc26669c58475edaf7e36"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0aaa8e641dfb4e84136122d1035f1e1f44280d5942889f891e2b97256d87718f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0718562e716556ced713d31acc3095b0a2c9453dc7b27885830d8a45aa01bba"
  end

  depends_on "ffmpeg"
  depends_on "node"

  def install
    system "npm", "install", *std_npm_args(prefix: false)
    system "npm", "run", "build"
    system "npm", "prune", "--omit=dev"

    # strip the foreign slice of the universal binary to satisfy `brew audit`
    deuniversalize_machos "node_modules/fsevents/fsevents.node" if OS.mac?

    # keep only the prebuilt native libraries matching this platform
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    keep = OS.mac? ? "darwin-#{arch}" : "linux-#{arch}-gnu"
    Dir["node_modules/@{libsql,seydx}/*"].each do |dir|
      rm_r(dir) unless File.basename(dir).start_with?(keep)
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