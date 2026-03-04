class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/coder/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-4.109.5.tgz"
  sha256 "fdceb72398a928f005399ed1e0c939b69da7d2ba7739add9136345b41854f998"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3bdd7a0c27f22a50d13e8ef2911b748eb186c7c213a36d93cd1b98ac0a999fed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f293724c8f56ded979a7b73308363673ac2d83764b0cac33a6017e57b6d9a61f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9761a307156d2e92b0141f801ec6d18a32c2e895adccb1bab41d300aea3dad2d"
    sha256 cellar: :any_skip_relocation, sonoma:        "4defd4e102a8b0bcc79a752208d64cc49e45f72248e41a28b8d0630c1f56e8ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cfe399b38a832ead36dbf9ce2d49b74a67dedbce1dd38443604278ca0bd0bc4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00d4c8697eb151c49d3c42b2329dd04fbc98a1aacd6af5d83077af7d7ca2ca45"
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

    system "npm", "install", *std_npm_args(ignore_scripts: false, prefix: false), "--unsafe-perm", "--omit", "dev"

    libexec.install Dir["*"]
    bin.install_symlink libexec/"out/node/entry.js" => "code-server"

    # Remove pre-built binaries which are unused as a source-built binary is available
    rm_r(libexec/"node_modules/argon2/prebuilds")

    # Remove non-native binaries
    arch = Hardware::CPU.intel? ? "arm64" : "x64"
    anthropic_node_modules = libexec/"lib/node_modules/@anthropic-ai/node_modules"
    vscode_node_modules = libexec/"lib/vscode/node_modules"
    rm_r(vscode_node_modules.glob("@anthropic-ai/sandbox-runtime/dist/vendor/seccomp/#{arch}"))
    rm_r(vscode_node_modules.glob("@anthropic-ai/sandbox-runtime/vendor/seccomp/#{arch}"))
    rm_r(anthropic_node_modules.glob("@parcel/watcher-{darwin,linux}*"))
    rm_r(vscode_node_modules.glob("@parcel/watcher-{darwin,linux}*"))

    # Remove pre-built binaries where source in not available to allow compilation
    # https://www.npmjs.com/package/@azure/msal-node-runtime
    # https://github.com/AzureAD/microsoft-authentication-library-for-cpp
    dist = libexec/"lib/vscode/extensions/microsoft-authentication/dist"
    rm([dist/"libmsalruntime.so", dist/"msal-node-runtime.node"])
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