require "language/node"

class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/coder/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-4.19.0.tgz"
  sha256 "c67887a475ac96d44d49e317b63f6a03fa63965f3f8bc36bfdfda734a80f418d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "16243de5e69d7a29cc9add7c3412a0c3a50f5b071cfb7a1c3850e14078bb53b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd40a1ee34872fee124c090ff7e04ee6ab48a59a51067cbdf3cfc5d648c625db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b72a264fe65f3c438d93c2e466f4ad278a560bf64f6dd9485bdf3e278855b9c"
    sha256 cellar: :any_skip_relocation, sonoma:         "2dc9b3552452ce0f053202e4c79a5d6d4ea8dc6a17fcaaf9ea17eda999ba3251"
    sha256 cellar: :any_skip_relocation, ventura:        "e93d4425c74bf3c69a879ff3df4c90d4cbbffcb2edd4fe3092ba9b71a8fbb39e"
    sha256 cellar: :any_skip_relocation, monterey:       "4cca46a16161b83ba9de2bc407e85b8012e40767126052e46e566a1bfca18f84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "715c74dffa9a544cd5f3165493461239f05f7d5e77dd2a634634a2ecc927c72d"
  end

  depends_on "yarn" => :build
  depends_on "node@18"

  uses_from_macos "python" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libsecret"
    depends_on "libx11"
    depends_on "libxkbfile"
  end

  def install
    node = Formula["node@18"]
    system "npm", "install", *Language::Node.local_npm_install_args, "--unsafe-perm", "--omit", "dev"

    # @parcel/watcher bundles all binaries for other platforms & architectures
    # This deletes the non-matching architecture otherwise brew audit will complain.
    arch_string = (Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s)
    prebuilds = buildpath/"lib/vscode/node_modules/@parcel/watcher/prebuilds"
    # Homebrew only supports glibc-based Linuxes, avoid missing linkage to musl libc
    (prebuilds/"linux-x64/node.napi.musl.node").unlink
    current_prebuild = prebuilds/"#{OS.kernel_name.downcase}-#{arch_string}"
    unneeded_prebuilds = prebuilds.glob("*") - [current_prebuild]
    unneeded_prebuilds.map(&:rmtree)

    libexec.install Dir["*"]
    env = { PATH: "#{node.opt_bin}:$PATH" }
    (bin/"code-server").write_env_script "#{libexec}/out/node/entry.js", env
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
    # See https://github.com/cdr/code-server/blob/main/ci/build/test-standalone-release.sh
    system bin/"code-server", "--extensions-dir=.", "--install-extension", "wesbos.theme-cobalt2"
    assert_match "wesbos.theme-cobalt2",
      shell_output("#{bin}/code-server --extensions-dir=. --list-extensions")
  end
end