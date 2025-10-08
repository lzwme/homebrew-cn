class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/coder/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-4.104.3.tgz"
  sha256 "27dfb0567eb59862cfc78c1a320ef74af0b590005426253a7c35538809353026"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ac59a336c7b47a370ec6d596b2024e5cea243ca53a987349e4857a546bab614c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26731dcdbd4c0dca015301fd2b15db5db0e660e6a4f00e9fec5adf8b9407323e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e3f7dc6a8820c775cbe3a5539bb4d96f5b17a2b89931e34caa9d3888d532adc"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee7c477b51dc91fced1008acd3660630456b3f4e02170e2581b9613830860437"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8ee99614681209317a3a0749d31b513e5f7e871f120d09c21c150e3d4139260"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5860ad756a7ff85459df953e101d01e103f5e4a6c05d02f371c0069d3ec1716"
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