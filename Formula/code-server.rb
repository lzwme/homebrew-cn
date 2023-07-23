require "language/node"

class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/coder/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-4.15.0.tgz"
  sha256 "18ec43d387e1c10684faaaa20591420a75f2431ac32a5302df481e607392abdc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4dfd551303b2ffa9761722f4994f5fc29c0ca03d993922dff68ba6bc2a31f0f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11ccfd8a9e91d5b7ff58fb69912785a6c69dc1f427ab8b03ae47692045aa69d3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7c2fc5fab120d0a2efbf2ef6d6cb2e83053859ae72b8b6d48786695b151eb24f"
    sha256 cellar: :any_skip_relocation, ventura:        "2b034b412d7c89cd10ed01c7cb48e45f2a699ddabf37ac8c91c514d89cf11a53"
    sha256 cellar: :any_skip_relocation, monterey:       "76fdeb029cf859bf95ee7919df5198d156c6d7a4fc64abe931538bb19d56024a"
    sha256 cellar: :any_skip_relocation, big_sur:        "0975be8a23c3f3f5ecbc64bae91d9aa848b50ca9102340ced6bc1b6796f8d3c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "938b67f7b6b6bd3e314cfa29e5b05f08332b048135454a4e8d0fc81065eb6af3"
  end

  depends_on "yarn" => :build
  depends_on "node@16" # Use `node@18` after https://github.com/coder/code-server/issues/6230

  uses_from_macos "python" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libsecret"
    depends_on "libx11"
    depends_on "libxkbfile"
  end

  def install
    node = Formula["node@16"]
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