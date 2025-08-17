class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/coder/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-4.103.1.tgz"
  sha256 "c10ce0856af1f45ad9b41b1de21d938a3e65034f2ca0d80f51339f8ca0b775c5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca097140c0ebc615efa7b8ebfbd84ed4733ea2f829a37e73773c6c756f1a56e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b90cf9021947aadc07f5ef2d49a0fae2e255248d3c3d8cff20171a97e7caf00e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "88b5b071aa48358108d838bc697661298de0db78be8ee59f50a45e23f241f7eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "02d261643e45355599d05c873ac088677d0afe894bda3b4a66e5261a94c13bd5"
    sha256 cellar: :any_skip_relocation, ventura:       "f3d656e33cc4e9f39b91fedf289beb12bce00433d56fca75b002867d29b064ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23b9f5a8d668541aed71ad3b2948e406e1b2be592183bd0f583bcf8500b7e95f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03b0e836fe24a0a47a10d058b4633e24eb40f7dea1c2a1f27ebf040e51cb534f"
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