class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/coder/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-4.103.0.tgz"
  sha256 "e989832b906b7bd3ebc2beaa5c2321f7b522ff40700825fe0348dca0999ecd63"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3aec6623749f667db5357b43babef56f613c1426b836874ab9e9c9e17127057b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73d2f2e6256349b7200b43fdff12605cfdd78b459d88a96cb472ada9b7c340e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fa992c2a9b4872a3b660f5794f091ffdeb707aa0f72ef4a8397628a6b4029732"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff28facb47738342f6794c978ced64a86dc0fa9ba297bcbfbf4833bf6e035498"
    sha256 cellar: :any_skip_relocation, ventura:       "0a2747a0bb6893a962dba9a4a0f99ce88125a552a0647b06436741de7314f2c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e2ca43cebded6b86e160b6403391b8337c4c74b6d125b72a13928f8765d7692"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a522bc7480b10933ef023d8ab38d116b45c60101e25ec211910d276d91319f7"
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