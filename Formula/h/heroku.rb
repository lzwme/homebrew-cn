class Heroku < Formula
  desc "CLI for Heroku"
  homepage "https://www.npmjs.com/package/heroku/"
  url "https://registry.npmjs.org/heroku/-/heroku-10.13.0.tgz"
  sha256 "3ac256df599c3b1ef149066d1d64f45db182b1767e9c2b67c61161cb306787be"
  license "ISC"

  bottle do
    sha256                               arm64_sequoia: "df9ebb29bdf473a6876f8d85a972c0d6e16fa231d54de32e2a26148817282c7c"
    sha256                               arm64_sonoma:  "14733690a78eb24a52d82ecaa374e65f4f11135e317b20a02b11206a08e63a87"
    sha256                               arm64_ventura: "19111839ff7ab40eab9b63171e93d024c18af114e889012f6bdad2bb5d202238"
    sha256                               sonoma:        "f254c551c0b4d2e3fd4b8c68d955ed0e52695791e5ebb2327a689d42f29451bd"
    sha256                               ventura:       "53c08969409e0b8e6cfcbf7fc67811576ce677e2a7b6fd013a368b929b77227d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f2626a1dd7dcfd465b0afc4d30e12a830ac0b55fcd5456c2eceea2f9c9debb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69b1b30666f0e92af6b3d4e852f7cc4654473e4a2801a69752101557d54283c8"
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