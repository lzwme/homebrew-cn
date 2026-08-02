class Lunarr < Formula
  desc "Self-hosted media streaming server and Plex alternative for movies and TV"
  homepage "https://github.com/lunarr-app/lunarr-go"
  url "https://ghfast.top/https://github.com/lunarr-app/lunarr-go/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "44bd0642bc69fa3f7899f57472a3a139a6f43ade9487057b598d0243a6b746c2"
  license "Apache-2.0"
  head "https://github.com/lunarr-app/lunarr-go.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d0a5fb8854913128e9d856a75f1d9da732bf524bc1c1cdf13c3e961a42f4283b"
    sha256 cellar: :any,                 arm64_sequoia: "28b39545813899ae0ffe2f4acbb74372f0c2ffc57bbd24f7d15e7e60bc40dc91"
    sha256 cellar: :any,                 arm64_sonoma:  "b5ce20419b1e40e6c5e3c451b4192cac7b1d989d705fd4c48c87ee60f464642a"
    sha256 cellar: :any,                 sonoma:        "30b53055df963ab0fa1f8de5ea69c5cb7fc18a2e4b1715f570a40d4badd7925a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a6514fd5d48f6ddfd2b899e3dc912f74b3e048560438733b6e77fe947cac83c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69ce6b4bee4ea707eadde7af50faf9f1eb8a5d96df5423ab34e1d0c3cfbba582"
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