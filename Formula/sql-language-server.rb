require "language/node"

class SqlLanguageServer < Formula
  desc "Language Server for SQL"
  homepage "https://github.com/joe-re/sql-language-server"
  url "https://registry.npmjs.org/sql-language-server/-/sql-language-server-1.3.2.tgz"
  sha256 "2631573102895bb002ebe07d62f3cc0c907ad4e7b75d4c737abf7c2d31052671"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "476969435c23bf8cdc0239ffcea49746b721743b38a3f806fa9118fcbf4518f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40fd78130749ef35ecd5e10acdc1f17ff10e5a5fe795ca96d17d54123dd8cf3e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4ec93b144a23e45f0a7124b28b657a51312cae28c58e4b53a1d2410e30eea432"
    sha256 cellar: :any_skip_relocation, ventura:        "e2bd7c3bd3a999e637ac9b433fbaf1d97230b0772a6ea33331c0821c6bbbfa56"
    sha256 cellar: :any_skip_relocation, monterey:       "e1887d0649453f493d2b0d223a20badd8bb141d30e600bec944f1fae4613f660"
    sha256 cellar: :any_skip_relocation, big_sur:        "49db52f3ef1a043cafbce9b0370ff63c789362b306ecb0ad9e0d437f79aac870"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b3ceb4de69ee6f04c8e2536613941c6feec1e6dc173febbdc392502b084b558"
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