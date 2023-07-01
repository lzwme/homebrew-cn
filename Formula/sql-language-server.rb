require "language/node"

class SqlLanguageServer < Formula
  desc "Language Server for SQL"
  homepage "https://github.com/joe-re/sql-language-server"
  url "https://registry.npmjs.org/sql-language-server/-/sql-language-server-1.6.0.tgz"
  sha256 "7b8f5e0fdb33eca26e23f6746d83bda049aeb30f61e14e0f43008a7b50f19dff"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fe268f9aace5feffc1051e8785db75eda1f4285cbc0443f39f58413e653a8e0a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "24eefd8fd1e42b1e0a4f30bea091ddf99799a6783de04d495bbdfaee0aa5afcd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3f06002426c8c0ec6235de59a30277564bc06dea21791b5cbc12c8167b580451"
    sha256 cellar: :any_skip_relocation, ventura:        "fbab9e400bb0bd8c7f1f97abeccd2b124714b5230c6a3c5adb1027eee327aacd"
    sha256 cellar: :any_skip_relocation, monterey:       "2153801a2ecff36c125e5d0824158d74d53361e88c50ba7edf6813101201367f"
    sha256 cellar: :any_skip_relocation, big_sur:        "aa3bc88e3b3d3a4a535ed1e0783e440e3abd8b2cfb040f727501449b2d7adeb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "438a160bf72d0df51e42c9ef6c4b114d5e4d9d0384d49c886301a292672b1463"
  end

  depends_on "node"

  on_macos do
    depends_on "terminal-notifier"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove vendored pre-built binary `terminal-notifier`
    node_notifier_vendor_dir = libexec/"lib/node_modules/sql-language-server/node_modules/node-notifier/vendor"
    node_notifier_vendor_dir.rmtree # remove vendored pre-built binaries

    if OS.mac?
      terminal_notifier_dir = node_notifier_vendor_dir/"mac.noindex"
      terminal_notifier_dir.mkpath

      # replace vendored `terminal-notifier` with our own
      terminal_notifier_app = Formula["terminal-notifier"].opt_prefix/"terminal-notifier.app"
      ln_sf terminal_notifier_app.relative_path_from(terminal_notifier_dir), terminal_notifier_dir
    end

    # Replace universal binaries with their native slices
    deuniversalize_machos libexec/"lib/node_modules/sql-language-server/node_modules/fsevents/fsevents.node"
  end

  test do
    require "open3"

    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON

    Open3.popen3("#{bin}/sql-language-server", "up", "--method", "stdio") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end