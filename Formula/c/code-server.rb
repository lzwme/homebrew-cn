class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/coder/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-4.105.0.tgz"
  sha256 "73fc1873bc15936eb6bb7a133b6201e6bcf60a5a410190168626381126079722"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "627d5dcde5fc4a7572dc6a7e8d2a8f0661503bdfeda9912758cb8faf6da47361"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40bca4ae5a5c0feacb06cd8c3f0ecfb8cd57b3a5602486470c79db16a1172d1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "900ba8d417cf529712f62263339571620e94147c6e2be0a1f3bb923f4954ed02"
    sha256 cellar: :any_skip_relocation, sonoma:        "b37a5e4716c1a6db65210e6fb5693f7adf3c5c98ad241bb50c23d4b5463e168e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "68b8da404bcfcf9a5b3744932b40a64becb3782cdbc4d91aa538f2ac54f042d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46c6beef5532b8c377df5e0942d487e33d29c89029274daf689632a121f892cc"
  end

  depends_on "pkgconf" => :build
  depends_on "node@22"
  uses_from_macos "python" => :build

  on_linux do
    depends_on "krb5"
    depends_on "libsecret"
    depends_on "libx11"
    depends_on "libxkbfile"
  end

  def install
    # Fix broken node-addon-api: https://github.com/nodejs/node/issues/52229
    ENV.append "CXXFLAGS", "-DNODE_API_EXPERIMENTAL_NOGC_ENV_OPT_OUT"

    system "npm", "install", *std_npm_args(prefix: false), "--unsafe-perm", "--omit", "dev"

    libexec.install Dir["*"]
    bin.install_symlink libexec/"out/node/entry.js" => "code-server"

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    vscode = libexec/"lib/vscode/node_modules/@parcel"
    permitted_dir = OS.linux? ? "watcher-#{os}-#{arch}-glibc" : "watcher-#{os}-#{arch}"
    vscode.glob("watcher-*").each do |dir|
      next unless (Pathname.new(dir)/"watcher.node").exist?

      rm_r(dir) if permitted_dir != dir.basename.to_s
    end
  end

  def caveats
    <<~EOS
      The launchd service runs on http://127.0.0.1:8080. Logs are located at #{var}/log/code-server.log.
    EOS
  end

  service do
    run opt_bin/"code-server"
    keep_alive true
    error_log_path var/"log/code-server.log"
    log_path var/"log/code-server.log"
    working_dir Dir.home
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/code-server --version")

    port = free_port
    output = ""

    PTY.spawn "#{bin}/code-server --auth none --port #{port}" do |r, _w, pid|
      sleep 3
      Process.kill("TERM", pid)
      begin
        r.each_line { |line| output += line }
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    ensure
      Process.wait(pid)
    end
    assert_match "HTTP server listening on", output
    assert_match "Session server listening on", output
  end
end