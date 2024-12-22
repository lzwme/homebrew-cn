class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https:github.comcodercode-server"
  url "https:registry.npmjs.orgcode-server-code-server-4.96.1.tgz"
  sha256 "024955288ccfd3c4b2e8737a17ee7e4ee9877ed7d493e8dc7b3f556b12dbfb1d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1a0b4a60336b6e7a43d5690f77c59ec2d76aadc8664ff1ba6e503bec07046c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4cd794d40e45a4c27a115d79923d6664c829875734506e75f017b4afacc2cf33"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "858cb31911ae6753ed1d478e7140ba0d5fd014d5f726993945a2c2c1e70445fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b3df3665a71ebca33b8b74278134e9d584201b9a83f54c49eaec49cb8f5b3f8"
    sha256 cellar: :any_skip_relocation, ventura:       "2db7a845d02e94b0e72b83400835ded35e54a88784404d042f3b348ccfa365ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5efb4f51fe4068b6fb796e5f7b2d6c665dd59dc6142b8b47320f2e877280cd4a"
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
    vscode = libexec"libvscodenode_modules@parcelwatcherprebuilds"
    vscode.glob("*").each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
    vscode.glob("linux-x64*.musl.node").map(&:unlink)
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