class Heroku < Formula
  desc "CLI for Heroku"
  homepage "https://www.npmjs.com/package/heroku/"
  url "https://registry.npmjs.org/heroku/-/heroku-9.5.1.tgz"
  sha256 "1dd66255bdc57f742c091671b2f84f6ee4faca8b9bd967d8528678182cf2a6b5"
  license "ISC"

  bottle do
    rebuild 1
    sha256                               arm64_sequoia: "19060376f155c309d050355d9f78823a9be221df1dbf6f11402ca9ada75f399a"
    sha256                               arm64_sonoma:  "d8371ba76935d5c727e4c2f0b2853215a56357abbf0fb276af93645fb80961df"
    sha256                               arm64_ventura: "473a9c940a0003fab9bd09d08656b6493299428cb0983276b0373f864ae073c7"
    sha256                               sonoma:        "8f3e25edc33cfbf915df0434c654e955bb7fced243ecbc4ff99be9f0b6a98f5d"
    sha256                               ventura:       "39855f46b5621d6bf834f6e5f41bf2d2e05b128ae8c2e73b13bc68dcc6cd0d07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d691d12686a10fa66d79f7cd480a2eb58bba53fc162a173fafb40bcbdd34b85"
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