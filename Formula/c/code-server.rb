class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https:github.comcodercode-server"
  url "https:registry.npmjs.orgcode-server-code-server-4.100.3.tgz"
  sha256 "a85138ac3a382a9ba1df652a751901ec598fed24f673b8a8653de7be8335bfaa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09e14227ff4b741288f6ced6167c23155a2e6f1e80ad3ed08a0d8f9a37dc6ac8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1696b9c600b76e5be899517c44c5b32e02cd44383af2c8e088a4f07bc5625fe0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6ca625738f45d0495b2ebe5d33943d8edced735f7e84d06806c9a3868ec2414f"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2fe2692846bcf26211c9a1fc079026c86a295758c18bda519519d67ada3677d"
    sha256 cellar: :any_skip_relocation, ventura:       "f52a6d36e616752505a3861e7486fb65e1ffb20c60165970f75ac1642d4594e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ccc372a687625ce6406fd8a0aa6b96298919bd90c885e2aaff31b73a6fb2943c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8dacb160e8191384e2d106139f990fc3d3b701244e5cb86ca7a550dfca78d26"
  end

  depends_on "pkgconf" => :build
  depends_on "node@20"
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