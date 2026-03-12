class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/coder/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-4.111.0.tgz"
  sha256 "188c0fbe96cd5602e05c80e4636cc7aa20af95cc222ba7abfcd7f87562728bd1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ba9bf4654740eed1df567f7c4d30e0db549f563f315e8ff41da98e7c5dab29b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ee59877d9c15084482bc69bd635c2d70dab3568f55ea19efd8d903bc04345ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e6f9361a0a12a1d8e822078107ab383d43abc9b6e724d4c30147428bd05a5be"
    sha256 cellar: :any_skip_relocation, sonoma:        "e990be73ea70067e77cf1f830213280f9756652dbc53c8a140a79d52c74198a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5dbfc015c75027614d188deb4eb3637668e554a2c52ed5f6198726eb6da2554"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "365bb459647a46ba029a7f7420267ff2427d3825cb65530277d8656009c1ddb4"
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