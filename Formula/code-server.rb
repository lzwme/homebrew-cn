require "language/node"

class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/coder/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-4.14.0.tgz"
  sha256 "273582cf89c34c841fcf4de683cf99a68d9c39198dbe11779bfd5992a34fdda4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8b33fdd7205ecdfbc1a0dba8addda67c5c080df719cfc5b453dd91b39b23eb11"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "87203b9614770cfe8dad4b01931856430c75406e40279dba876eef2af1d94515"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "905d6b0fbbc2c34efe2b46cc0d7883ffa3cc6862fa32b194cd1f49c7e7ed5f9a"
    sha256 cellar: :any_skip_relocation, ventura:        "1de605d4621f72cc0f03382e0a1bf8428714d7f955bda302ebae144147fbb514"
    sha256 cellar: :any_skip_relocation, monterey:       "41300f012192a3cfcc0b5817586c19acf577084a758cc367d985877e90abd273"
    sha256 cellar: :any_skip_relocation, big_sur:        "69cdb15d951791fd9fa84d5bae3267bf895f2a06e542732fbdbfa60649b87304"
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