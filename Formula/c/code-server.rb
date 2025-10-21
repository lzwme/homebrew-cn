class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/coder/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-4.105.1.tgz"
  sha256 "4a716e1f6294eecde5ffdbfa2af146df91991ce53115d4d3e8e86d101b2101c9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e94eb55d2deb5c2076abe720bbd5149e4828db1ff294bdb72bd2dc473c19ec14"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93d9c0755bdc8d848c0bbf0c395283f58e1d87cb1e23b75735fc1f516c452d19"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8ee927ed6da8dfdd3a198ec68e753dc1a84fda1981bf57d55a6f6f225813c39"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a80402618b04f77cbc21372b45a97f1d75f0eaf7678c6247246c381627f544e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3224ec50593d8b165dba3df4f78edb2e0c9346e61b7f9f805f01ea18ef075cee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b94ac571bb34fcefda67d9b2fc18b929341667927dba4ea063bc5d10016a33d"
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