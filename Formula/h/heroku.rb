class Heroku < Formula
  desc "CLI for Heroku"
  homepage "https://www.npmjs.com/package/heroku/"
  url "https://registry.npmjs.org/heroku/-/heroku-10.10.0.tgz"
  sha256 "0270050995643d37f9f024ae258df3ad2a0d6c0b60291781d26724fe1adb1bbe"
  license "ISC"

  bottle do
    sha256                               arm64_sequoia: "efd4904a8c584c7348d4732cde3f257f4b374379c3faf7e549b2297c59d089d6"
    sha256                               arm64_sonoma:  "36313d308586dd377e6cd585b0b954f942ad4290d81a8846f7ec8d95dcb82326"
    sha256                               arm64_ventura: "f4443ec1b325033b6b01cb6096e49ab2534fe49e889f7d1399aed989ed95c414"
    sha256                               sonoma:        "f28191ab390d04fbc95a301f6ceff3d3b72e1dd1e40d11b7e03fd0eacb09994b"
    sha256                               ventura:       "ea2576656f7c0b9650db8b522e935dccbd8ac27768656bdb9f48ea8ac9a5e147"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9051cd6f5f4555594dca48202650711623a9e241bc8a9a24e4db5ea7f96d63e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63b4d7e2c0e04bf62e8d506387203b945904c5808de089c3f76bbf4fe57c43a1"
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