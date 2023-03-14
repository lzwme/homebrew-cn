require "language/node"

class SqlLanguageServer < Formula
  desc "Language Server for SQL"
  homepage "https://github.com/joe-re/sql-language-server"
  url "https://registry.npmjs.org/sql-language-server/-/sql-language-server-1.3.0.tgz"
  sha256 "c979bf37850ba2cb139892e30b0d249df3640dbaab3b4a567c8af967fbe9837a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c598108ec90e8ad540910b3c7cf49a997cfe77e550dde1c99033851dd6385e7f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e6077dd810546681c36241382cc2f90b25e96644a326589d52ab17111aa05e7f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6b0881b12e78d0bbe06dd45973edc4050452118e6b072789eafd72c7e698fd17"
    sha256 cellar: :any_skip_relocation, ventura:        "acb7d5e7ba13af7ce76ed44a286b4c6c43c26b8ff593245b45e9f8c100aec27b"
    sha256 cellar: :any_skip_relocation, monterey:       "29ed8ce8ffc597445d3833c61deea53370f6a8b96349a6f296079b87baa95479"
    sha256 cellar: :any_skip_relocation, big_sur:        "3c6bf877228f6cd2809f002fb748f630be3606c4548324deafd78be6582ed2e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50d3c45d61944156cd009d5df16cb6bb32419e058f605d2330bb4c9546410155"
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