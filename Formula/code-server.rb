require "language/node"

class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/coder/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-4.14.1.tgz"
  sha256 "b8cba290805f3cf6f48f8d9b529283ca1d23dfa7645ff2ef23c2a6209744edde"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "68151a4380f7c006cd27f35cfd9f57dba859f05ee7eb4c93bdcb36e77abd108f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3dc72604b2233f1f38886d67cc35fd25fd021147f2dd46d5baf642c8ebc1e7b7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a1f44f495e838a462dffb37d850b5061a63d33df61c23e81bb59fa08c2cc7454"
    sha256 cellar: :any_skip_relocation, ventura:        "4c2befea86daaf14d4532d589fa46fe9e7ca23f81becfbaaddb86a1cf5b01b4f"
    sha256 cellar: :any_skip_relocation, monterey:       "864b4ee94b00f7c212f8e393de996b2c45f3ab1437b6e0db14f2bd5044ba84b9"
    sha256 cellar: :any_skip_relocation, big_sur:        "d6e071833a33ac798af59e0124fa5531022b69645a779db471f18a465140c890"
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
    prebuilds = buildpath/"lib/vscode/node_modules/@parcel/watcher/prebuilds"
    (prebuilds/"darwin-x64").rmtree if Hardware::CPU.arm?
    (prebuilds/"darwin-arm64").rmtree if Hardware::CPU.intel?
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