require "language/node"

class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/coder/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-4.14.1.tgz"
  sha256 "b8cba290805f3cf6f48f8d9b529283ca1d23dfa7645ff2ef23c2a6209744edde"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "749c12e93f5e825d22128739ced4cf458528e03455e330e0c60dc74f734fabd6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eea7b3179664dd0b7d38d8f01b862d25522a252e8a841ebc6c670d1475955777"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2e2a26eb2232e200d9c4e6bed5b1f05ee8253462a5657b94d7e138f018bc8cc4"
    sha256 cellar: :any_skip_relocation, ventura:        "a074d018da36ef3f92bf332e14fae2e5de4a1e40ce55b840ed004a0f8d355020"
    sha256 cellar: :any_skip_relocation, monterey:       "ec5ae4ee570b60cd9104ba812d35b436f111b761c94c06ce9e9ab52198eb3a31"
    sha256 cellar: :any_skip_relocation, big_sur:        "8492813a615330082dca9b87eea89143773d140b12f24868ff15f9acc0eebd41"
  end

  depends_on "bash" => :build
  depends_on "python@3.11" => :build
  depends_on "yarn" => :build
  depends_on "node@16"

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