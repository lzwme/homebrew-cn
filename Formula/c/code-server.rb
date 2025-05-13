class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https:github.comcodercode-server"
  url "https:registry.npmjs.orgcode-server-code-server-4.100.0.tgz"
  sha256 "dd75fcae2b8a6fa2915ac12b36c303dad53e06477c2c8711be369f67c806167f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5975934b3348c36c66861d388c3893c513f71ecca7fb0a9369c7cce6a0703771"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15113fe9ccf013ce066cf2b2fa6006e82840066bdd01d50952e1b97bf3511cc7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a298d3d8719ac3422edd5443a6a51ce9493d9bacb0a8f2ebbd4c54040f348c83"
    sha256 cellar: :any_skip_relocation, sonoma:        "004d94732d89832c299a03c80aa8f357e289c529c54e66168f1550803ea3da52"
    sha256 cellar: :any_skip_relocation, ventura:       "5cc418648d1e8c0be58d65e29c64b391a6d7ab8c17a96dc62936922ddb4f8ee0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "007b81e70e97ddee947027e7006a2a018cadee988cfde5885c112d363e9809f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0064f005107677f5adffccc8bb03693a6d9c7c6c933cc11632fafe4c39acae13"
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