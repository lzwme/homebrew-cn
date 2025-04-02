class Heroku < Formula
  desc "CLI for Heroku"
  homepage "https://www.npmjs.com/package/heroku/"
  url "https://registry.npmjs.org/heroku/-/heroku-10.4.1.tgz"
  sha256 "5dcfca6e37c8acf9279d193ed8521c00bc7c4d7c19da6dfc8bf838fb2b5254fc"
  license "ISC"

  bottle do
    sha256                               arm64_sequoia: "7443b3b463f6ae53cc5b0695334eef66947e5082b004f0ff9887a7f990aca540"
    sha256                               arm64_sonoma:  "775b1a9bb3e1416626a3423aea22559dc8f7727fe97d63dd460addbe29752c12"
    sha256                               arm64_ventura: "299eb7654bf3f8ec1d9c6d064c56b165dd62d819a5cb8514f70edbca0a59ddb1"
    sha256                               sonoma:        "292086a29760ac21296cd384b578e03b4a37221e17cd242820c94f5dbb34fc9e"
    sha256                               ventura:       "4353c5af786ab4d4e4021dad44a1ce4e01ff0a2b29ecf246ae7b782061e18c51"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18f043039746b7e95ab43a80bd6d2fa474c4c04761b07a4512656e8d0543a3e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a520d237635cc118eb6390bdfd045d3cd040a85795f460e4d335697b69138c35"
  end

  depends_on "node"

  on_macos do
    depends_on "terminal-notifier"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    node_modules = libexec/"lib/node_modules/heroku/node_modules"
    # Remove vendored pre-built binary `terminal-notifier`
    node_notifier_vendor_dir = node_modules/"node-notifier/vendor"
    rm_r(node_notifier_vendor_dir) # remove vendored pre-built binaries

    if OS.mac?
      terminal_notifier_dir = node_notifier_vendor_dir/"mac.noindex"
      terminal_notifier_dir.mkpath

      # replace vendored `terminal-notifier` with our own
      terminal_notifier_app = Formula["terminal-notifier"].opt_prefix/"terminal-notifier.app"
      ln_sf terminal_notifier_app.relative_path_from(terminal_notifier_dir), terminal_notifier_dir
    end

    # Replace universal binaries with their native slices.
    deuniversalize_machos
  end

  test do
    assert_match "Error: not logged in", shell_output("#{bin}/heroku auth:whoami 2>&1", 100)
  end
end