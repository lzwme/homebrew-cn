class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/coder/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-4.106.0.tgz"
  sha256 "72a2d62cc65c769ebcb84f1e94ea52cae98e4ba4ce3a893be5e815e71b9f145e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b44f1df39a5e7ce5821ed2be71aca30df29f9d49afe1ce4623eb80afd1f248c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc21d0ce2e25606512d6e9f73c223d77612fef6d09172daf55272712fe8186c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28f3cf7220943de6cc2efb55f022065ea200835e27064f19cde019e5097941b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "01acd6ab3695944b2b3fb8eb54c23bef28c980129b33ca68e12a9100fb44a145"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06a9170b846cd09129f5684d70def063448b78233acaf674a05ede5f3ea61792"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73bb57138f2c74606d6bd6617c48081979119249acad5aafbbc06adba28addbd"
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