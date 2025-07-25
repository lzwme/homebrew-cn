class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/coder/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-4.102.2.tgz"
  sha256 "5286d1ba8ac120d7d1939542ded5d7c37f891e3ba77711b1c7da749f5918cb43"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f9096cb4bee749664ee0bb9d77b815d9cfdd44bf7b3df7c7eeb95d2753a3500b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51bde9d35e3fda6ba43c1cd36985e03b42b6346fe59ffb96ac31e3065dcc4032"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "877007b00b30a87116c7f9174031d01b4421ac15434674fec301c3fe57a77849"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f6e39f03b571dcb9205a851865c06b94e31ff366263911eaa43c32ae1f0a842"
    sha256 cellar: :any_skip_relocation, ventura:       "d56992a67fd0532ad07071290d0c9a4c9176571a19fc63a68e45c17ea969c878"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d7212ec44d9ba11b992d26d67dff1b15baed76d55f30fb0d2a143e485afad85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9f95c5ba26bea299ab2fb8d4c916ac574ed0c0da01798d06b525d46d3525f59"
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