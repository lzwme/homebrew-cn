class Heroku < Formula
  desc "CLI for Heroku"
  homepage "https://www.npmjs.com/package/heroku/"
  url "https://registry.npmjs.org/heroku/-/heroku-10.1.0.tgz"
  sha256 "0e152698a489158e932f1fd8872c1152a5331d594efb7d5b8c81a65eb3aee357"
  license "ISC"

  bottle do
    sha256                               arm64_sequoia: "34f96d9a4cf809639c6f2ad679f3ff51f8e7711649dc71ed3c0d30f3c4a11f70"
    sha256                               arm64_sonoma:  "8cf09b86ae7460df68e9309fcd209e3464cd691d3cf2b796926639d6e73b5ee2"
    sha256                               arm64_ventura: "a677770a0beda13fd802eee902fc14d8a1c4cd3be620ec6539f6f7b22016c9ad"
    sha256                               sonoma:        "e84ce6a73c263f4bcfa3119f480fef597368f5ee6752446718d7a0ab2bbb984d"
    sha256                               ventura:       "a1602834735e14fcc8f8fd0fe6cac5acb2caef10d3fffbbbd51630e570462ae6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b33e7c7dbe9230cafe27f501e32a8f574b830f4c0e6036d4c723fcfc37da199"
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