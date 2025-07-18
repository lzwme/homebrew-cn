class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/coder/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-4.102.1.tgz"
  sha256 "5cbeca56410e350c4cd00c1f0e07743fe3f89f3efc66cd7d6de6ebc040bf4978"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "adcab45f40bb2b60bf6981ae6af1431c6b0130ef0fa5c1cfe9995850e4f751cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1a0beff5767736f7f7f98cd6e6384d2d39ca15a8356cf8d511c67f85d2d8c90"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4510388909dee5ff107a0042eefc6dcfe456f13764b5d0c37f654799253bbd7a"
    sha256 cellar: :any_skip_relocation, sonoma:        "80423390e82c4935917af424f1f8b7d59b0cb1f8da97b6461dcf940c7ba4c4dc"
    sha256 cellar: :any_skip_relocation, ventura:       "bd3b5b7a55b1ee5ce8069cb189ef060fc422db36e5df97e7fae707ee1731b761"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "24cb55ac4e2034f76b272358b4427b0643a12ddb49e139f5b53cea046815d406"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb514fddc5016d92668516439b32c6552460c3aefa97e7f4c923186a16b6476f"
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