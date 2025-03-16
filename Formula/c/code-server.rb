class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https:github.comcodercode-server"
  url "https:registry.npmjs.orgcode-server-code-server-4.98.2.tgz"
  sha256 "37d4ab6edfbefb5bbe4074cf3b6a3a5fa5cbd42eb273f324bf4bd70c3a801688"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a385886473cab18df5ac15dfee5db230db272d717bf2f48109356ef016ccabd8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b12fffbe3e1a6bb446c23a6273b4ef6a23ccd8ace0212d1df5f24a6e2035e64"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "15068e8a56365250c29b46cb3ab064a5e361a8462f524d26d06944c0cb10768a"
    sha256 cellar: :any_skip_relocation, sonoma:        "76e56814f0fc42ea9405396b59d20b961080d7b828f6781dea0d9700502db826"
    sha256 cellar: :any_skip_relocation, ventura:       "fd9a56c45b5facc138fe4b25f2e7808cb9680c409c4d5cc59e5aac701ed9e872"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "253451531978cb2487ab1d7d971d716a1f42714f7d62bb611826a4f408f38abf"
  end

  depends_on "node@20"

  uses_from_macos "python" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "krb5"
    depends_on "libsecret"
    depends_on "libx11"
    depends_on "libxkbfile"
  end

  def install
    # Fix broken node-addon-api: https:github.comnodejsnodeissues52229
    ENV.append "CXXFLAGS", "-DNODE_API_EXPERIMENTAL_NOGC_ENV_OPT_OUT"

    system "npm", "install", *std_npm_args(prefix: false), "--unsafe-perm", "--omit", "dev"

    libexec.install Dir["*"]
    bin.install_symlink libexec"outnodeentry.js" => "code-server"

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    vscode = libexec"libvscodenode_modules@parcel"
    permitted_dir = OS.linux? ? "watcher-#{os}-#{arch}-glibc" : "watcher-#{os}-#{arch}"
    vscode.glob("watcher-*").each do |dir|
      next unless (Pathname.new(dir)"watcher.node").exist?

      rm_r(dir) if permitted_dir != dir.basename.to_s
    end
  end

  def caveats
    <<~EOS
      The launchd service runs on http:127.0.0.1:8080. Logs are located at #{var}logcode-server.log.
    EOS
  end

  service do
    run opt_bin"code-server"
    keep_alive true
    error_log_path var"logcode-server.log"
    log_path var"logcode-server.log"
    working_dir Dir.home
  end

  test do
    assert_match version.to_s, shell_output("#{bin}code-server --version")

    port = free_port
    output = ""

    PTY.spawn "#{bin}code-server --auth none --port #{port}" do |r, _w, pid|
      sleep 3
      Process.kill("TERM", pid)
      begin
        r.each_line { |line| output += line }
      rescue Errno::EIO
        # GNULinux raises EIO when read is done on closed pty
      end
    ensure
      Process.wait(pid)
    end
    assert_match "HTTP server listening on", output
    assert_match "Session server listening on", output
  end
end