class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/coder/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-4.107.1.tgz"
  sha256 "82df6b608d8dc6acd747bb6d6d60e4e80462f12d8d295b9c43bbbbdcf514c8c2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d54e0b951ad876e957af61208407c3677cfc533b70b4a69692740df14c76e7f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d75494d3b96d980daf367e4fb772bf6d0deac3e0bf873e128f954b27fcb8acfd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "704f46476ef33fb80e2cff90af80bb29456a6a8da612532e9eb1f0af2262a9d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "765648122f691255b3de6822cd250dda2fcf932a50676047f337024fef9feaec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8e91c0171a35fb15bc3c8a0ac2489994e3364cf9a023e78ebe541aa3ddb29fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2ec62bef70a731fae607386f984cd0f72f48cf588e864991e1ac93a56c6c1ae"
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