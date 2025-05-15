class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https:github.comcodercode-server"
  url "https:registry.npmjs.orgcode-server-code-server-4.100.1.tgz"
  sha256 "d7841a1a61b1403888b7fe2bef6c1a928a038dad52fad36fa2062ffe2bd98c84"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2e3a541a5a8441fff5980d2cf051deaa8ed6c1231dfc0f1bee25526b5399565"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "397fa2913a3dee751b32090bf8e005b4ba1c421457fd698115fd8ec9bf731609"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "19fd864c7ffbf5485ee62f7aa0b5a637050bc37a0ee9083e604a42a5678870be"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9c8cccf7d9a6fa29377858c77ae5a2ee404ecb5a32a8ecb7b9355df76743f8f"
    sha256 cellar: :any_skip_relocation, ventura:       "1c2ddec151a4a6075e20980dcb2a717e00b86f66b8292233daba58f53b9a1fda"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58d93953c31333efc76c813139581b8743893538c310e38db18beb060aaa4097"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0724c1cb51bfc1a63cfb82215e3d15a6cd8c266911d7e4986b5903549217518a"
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