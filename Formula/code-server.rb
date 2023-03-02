require "language/node"

class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/coder/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-4.10.0.tgz"
  sha256 "da4e4e4b03350d2897a7855004d89523e2ff6e95fb10601a9b744ee2e0f4d1e9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "07ea69322c25864e026c2253ac4f0ab84cee03a16f39b60de3fabecd4278e7b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b367e930e2e2ca9c6720fa7d900e971e3a422cdb6ef382b4113eac00a48f4ee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "079486bdb7411e98354d409a1052046385ffac292325f99176056da79a2b9d43"
    sha256 cellar: :any_skip_relocation, ventura:        "fd32bd56245424a200b4bcd72a9f50d0d4ebd6554f9a588aadd0d08b36b5ea94"
    sha256 cellar: :any_skip_relocation, monterey:       "417d271c5c2e3bb6949ec614aa5960622e6dc22038d97fe87f0e913a0d308e92"
    sha256 cellar: :any_skip_relocation, big_sur:        "3c70bd476d9d807833c3ddc13195d4ef3f072946223b01cc5a76c536f0f51b52"
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