class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/coder/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-4.102.3.tgz"
  sha256 "4fa1aa5ad723ed31bf56ee05f5673b824b0bc094c00881f8bca10515891ac0c9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c2920d8fa733f9a8f475baf14c297bf45d0e2adaa1fc4575eea2dc71d397162"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "381215080784b60b9d9e4383f40d1a1134f6ee445419e5268cd37a8921dd243c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fb5fd20d9874f3e021a5ab747dfa55dfcc2a19a3ccacb9758a8bbdc6d0e56986"
    sha256 cellar: :any_skip_relocation, sonoma:        "b15b2ef24822ff2b34c3858b422542d462e1177249c4f24b1c25cb4200a41b82"
    sha256 cellar: :any_skip_relocation, ventura:       "7032e2087b1253ae6fc4f0e487b1a740e7109f50bdde265a40c96214892c14ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80d9048627055c8c30db8bf3799a8b231f3da7854ab5d9c174117b2eadd8c783"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0f80a46e5324fc91fdc59180cdefb6ef99b4304dd8cbf55afc167ad5c0e3fa1"
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