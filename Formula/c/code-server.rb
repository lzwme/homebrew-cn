class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https:github.comcodercode-server"
  url "https:registry.npmjs.orgcode-server-code-server-4.99.1.tgz"
  sha256 "88e48dff2a244786621fe82963f73f4c5b2e1dc19684cd5e26e8e3d4faf84341"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "470a87adbe967965717358cb9fcc8d3101d917c6092422d842e84ebc68122993"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "744f3b610605f01481acf3774b5d2b90260559abf0dc5ef8732b8a1b093bcf87"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6a69e742adb9adcc96509d9740787cee71ceeea27d4a9e5e34f1e0740c7f0615"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe9b2e91bd0731cff584add13135da168464b6dd50925114202b2670e60ad013"
    sha256 cellar: :any_skip_relocation, ventura:       "044c0583dc1c7520a47fb23afbf0deb9ac864218bf5b12275ee238102c086b3a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a0c5039d18c64163884312e8a9b1e7eca953820624fca9f23c8b3fbf2ea0bb50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ecaea53ac4f00715bbe161adfbee3fd42c2024a05f73848fbba0bee6cbc96567"
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