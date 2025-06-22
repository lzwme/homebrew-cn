class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https:github.comcodercode-server"
  url "https:registry.npmjs.orgcode-server-code-server-4.101.1.tgz"
  sha256 "1d95bf4bbe07a924df134213d734b14b245cbc6a5f631dedc8ea87bf8b2cd358"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b238ba24fde40f37203648f66c51292671a25fcc842252fecee8f42ab43568b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b1da0875907e6bc247720547fc731c35b73ff54515c36f56b10c863c0937b80"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7dc4f6bcdeb92feccf9677df7a4ff4a4f843e6a400104441dd499496d988e771"
    sha256 cellar: :any_skip_relocation, sonoma:        "4603407b333051f4cb017a51577aa15d39e31506923e6ec55d70b211781deb6e"
    sha256 cellar: :any_skip_relocation, ventura:       "fa685582038e5aef970ac84d5f4bec6e093a60384b9331ef042bdb4d72e8a07c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6beef089984b3ff824f8912a9540120c1f926d7cd0fa9364a734b97f6f5c495"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ff5839709f290a120591111a4f5a1e8c5c14f9cfd5cf718861c6346fcc90e79"
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