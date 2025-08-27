class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/coder/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-4.103.2.tgz"
  sha256 "3f237fffd43f9bb423b7b4613b14d1aa422428ee12325d79bfbeda7e437cddba"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "660fcf2d91484417dc55a85654a16560aed520afd249fa7fcc724d10767c6cbc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48e0dd14c9058c25232e25a563e92ef24f640a7b10e2f86ece489f9b81806612"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aafd40e594ada5981fa227825467278e1e8b84648e6286dd865e302360593c16"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f570d6b590cd4fcb13ee9fcfc6f30b9e4cd8b6ab0d491b6843edea09b6f29c7"
    sha256 cellar: :any_skip_relocation, ventura:       "824509068b6a3a83aaeb199f997a1c5f93d2699005827a6537ffb8c73ffdc8c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f537f753d8bb2c97b214af2b35d5f5e2de3d29b7a1e6a2d75220780ca42e9432"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe37fed601a46e212f477113316a067f4e8daf0c8624abbe8d40532876d6eb50"
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