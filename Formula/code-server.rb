require "language/node"

class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/coder/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-4.16.0.tgz"
  sha256 "1830a7b6877a39ff51fecab3ee6007f68caf9771c50118842e6b6e7f4764f5c1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "08e8214130f29ee00f17a10027b6a5103b093ff29f053f9821fa113286047fc8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "707c0d71bb8836fd3f4e90b79d5fbbad127329037e36d8c74516c2ab03c27e94"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "369094a3a0455be9472e5924f2642c33aed0ec3c1ddbfba551bc6a750a1c8e62"
    sha256 cellar: :any_skip_relocation, ventura:        "fd3cdf298a071a934410db00b3942f0403e934878e9cf305bb2cec17894c2bae"
    sha256 cellar: :any_skip_relocation, monterey:       "073f667842bd9231e90c748d8a939bbab5b33bc3fc3cb96bb9411203c28142b1"
    sha256 cellar: :any_skip_relocation, big_sur:        "0e1f30553c1b35f924c4348409f9c2deab61615f9fd17f23f29765c8664304c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec7ca6986b476d6cd9fc1ecd8476c67725bcd5624449a59d4585283ec30cce41"
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