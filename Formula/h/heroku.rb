class Heroku < Formula
  desc "CLI for Heroku"
  homepage "https://www.npmjs.com/package/heroku/"
  url "https://registry.npmjs.org/heroku/-/heroku-10.5.0.tgz"
  sha256 "f999d2bc91be384e34cddd00a8557494eb80b0c366be5198d4d7360579f75af8"
  license "ISC"

  bottle do
    sha256                               arm64_sequoia: "4a6d5575398e2454914e3d64a29eb6464d57169368b7d2bb39ce3fc156da1ce6"
    sha256                               arm64_sonoma:  "676ed39be86d8f7fab01295d5c72e01bcffd269fc8a67138a98ffeeabb90b1e5"
    sha256                               arm64_ventura: "f82523025375281190f3a63f55976c741a2b701f03c9f5982481daa991f3f214"
    sha256                               sonoma:        "ab139065d8058c9315aa566146f31c8036e8d7e002a531b6e28e961eecb08208"
    sha256                               ventura:       "598bf46686516f4a6fec6f9fa622fb981df51648a51fca0f399e7ad5417d0164"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a18076c5bf798a307f62fbb50baf8219b5084dfe3ace5010c60344fae156f926"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5381b9f2bd540e7b88cdc782da6c4391456c7b17d7005493cd6009eaa74620d5"
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