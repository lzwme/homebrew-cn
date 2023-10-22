require "language/node"

class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/coder/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-4.18.0.tgz"
  sha256 "cd6356f0fd0924f104cd0ec00438d99e81e5d5373e3cc9658c266c1926c083c0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8043c60399e9636104195159d9f1cd7b0d4cc020a7a55ca55e73557c4a3918da"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "364eb5cbe76623605124df751b3ba264d09af914bee350a102ac9284fce5386c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f9f48c4f22f8c4216e9efa171232814dea0ccae2255f8d877a58d0ff961b40c"
    sha256 cellar: :any_skip_relocation, sonoma:         "6a7d32c1b163ab4a95143757040f42200a0d2728f0b4091278c4dca6a99771be"
    sha256 cellar: :any_skip_relocation, ventura:        "8f7831b6688b7da1216f32a622c7aec4ddd664594470638680bfc06f3f4134b4"
    sha256 cellar: :any_skip_relocation, monterey:       "e5e0f275db66d873b529c257e25d4032bbce714ef717b85f47a2849b9da38878"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9cb84ed75b9ccf7c275e10a53f7dc6732a29e1f72a47e60d220064de944be360"
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