class Heroku < Formula
  desc "CLI for Heroku"
  homepage "https://www.npmjs.com/package/heroku/"
  url "https://registry.npmjs.org/heroku/-/heroku-10.14.0.tgz"
  sha256 "ad4b30497602a38f701c184310c56841fd6fd51828f1821be71fe9e6f2f4ee8a"
  license "ISC"

  bottle do
    sha256                               arm64_tahoe:   "2c2e6a5607a473b6e7498401b4eac0ff26044412512295e8671fa962c222eba7"
    sha256                               arm64_sequoia: "518cf15165fe724a0638c533d4eae5c2c880f3e1b562156e883a91d42a029e23"
    sha256                               arm64_sonoma:  "847ffea9c7c21725900cf602fa85f07b05a25a7095caae9faea2a492f1464944"
    sha256                               sonoma:        "eef33870fed21ec3820c62d094f3c93420d61ced6f5f143c6b4c82f2e556700d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9d44434bed457fcfbf9cdd6be1112092c197ba93a1d86bbd6c8684d66e704c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a04d9a2bef28d925d062b7275eb5c83fa233e610e129f5d5aea96ec9fa53e1c"
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