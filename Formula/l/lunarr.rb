class Lunarr < Formula
  desc "Self-hosted media streaming server and Plex alternative for movies and TV"
  homepage "https://github.com/lunarr-app/lunarr-go"
  url "https://ghfast.top/https://github.com/lunarr-app/lunarr-go/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "e1b265fd02c88725e22e5b49eaaddae3e1e4d28f12f40b99ab5231c70f13d1c9"
  license "Apache-2.0"
  head "https://github.com/lunarr-app/lunarr-go.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "13021bccba7405bc903e47876acfe114d4954966a7844f3694a7e8a7e8dead24"
    sha256 cellar: :any,                 arm64_sequoia: "6ad159cd8d6b460d774f1abd74e89659bcbe552a78f6de40050d351d4515fe03"
    sha256 cellar: :any,                 arm64_sonoma:  "63a75f9a39ddc9162b018ececc8c8c5e62ba49d96461f728993b8f79cb733ae1"
    sha256 cellar: :any,                 sonoma:        "9239d0f337872320e8a6bf32e1742cc1463702c4687b918e50517d440c654f50"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "86179b943ac8c3f831f951f6fe0ff3f1fc3bd6120564d8038ef72cb3a54fd2c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "275f3f96a1e7dfafc9a5a851f12049e35325af7c80d95dffa9dc2d41d50cba05"
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