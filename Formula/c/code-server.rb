class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https:github.comcodercode-server"
  url "https:registry.npmjs.orgcode-server-code-server-4.96.2.tgz"
  sha256 "ec2359fd4e097dc918229acdf4eaf8b0b484d74cc32fd6c271d58d05d0da43be"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "423206dd1d7dcdace00c3e0e207588e430d5e0bf7b39edddca04b162affba67a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b012f0060b7a40787c670d6c90b26505a23d7f44e451c4bc7a673457f7704b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b4aef6c552480a68ea3edb4443ca794a2a5417e5121eeb0cd419fa4137535b67"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d85a559ad3b7361fe0b21ac12ebf12e56ba26ad7b86c96690aa1a5be2ddd46e"
    sha256 cellar: :any_skip_relocation, ventura:       "70de425621d9bca1a0e3b0d36fdc841aa85a3de9709c096bd982ec01f2beeb38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bba50f6180374d832f3315ff93fe53b02e1ea097f8ee3e38ad577d98913ad843"
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