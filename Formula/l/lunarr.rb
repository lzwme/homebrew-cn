class Lunarr < Formula
  desc "Self-hosted media streaming server and Plex alternative for movies and TV"
  homepage "https://github.com/lunarr-app/lunarr-go"
  url "https://ghfast.top/https://github.com/lunarr-app/lunarr-go/archive/refs/tags/v0.9.3.tar.gz"
  sha256 "984eceb73963d516cd0e57ca6fcf31caa0e58f658bd616a9adc380671e359398"
  license "Apache-2.0"
  head "https://github.com/lunarr-app/lunarr-go.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6d6a333637856f9a7acdc0e3de943170477acc9a1d6a238565d373696044d010"
    sha256 cellar: :any, arm64_sequoia: "dde7075afb283d9edb0dde568d33b39b57df63b0ceada9196a0bf0990f84bbc5"
    sha256 cellar: :any, arm64_sonoma:  "9b2148cacb3fd35261b431e52c5fe143413c1cf277583ab88bf2ed1bf5b01b15"
    sha256 cellar: :any, sonoma:        "fb1d8ee5a32f3db62aaa9a52cdf609ab6b858578ca7a9a30a9c7b3022649b105"
    sha256 cellar: :any, arm64_linux:   "3280392e53d1b8c60a6c163c9470022ff5cca8982f72835ff4cfd8370c1596a7"
    sha256 cellar: :any, x86_64_linux:  "c381359385f44be76c4363b083fe0c7e3fe97ab871792061b14c08725da64d07"
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