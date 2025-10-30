class Heroku < Formula
  desc "CLI for Heroku"
  homepage "https://www.npmjs.com/package/heroku/"
  url "https://registry.npmjs.org/heroku/-/heroku-10.15.0.tgz"
  sha256 "ca66cec0dcfc48d3621f361615793039d652ef0055bb2a82ff63abc52acd19aa"
  license "ISC"

  bottle do
    sha256                               arm64_tahoe:   "d9701cf66c3223515207350debad783360f40ed856a0279c60b172bc0fc98e11"
    sha256                               arm64_sequoia: "b583b62b7e789dd11a97e7d3d6abf970c265e375caacf2b3ce6b14659f3aee02"
    sha256                               arm64_sonoma:  "476be2a8c90d4e45cbf0b705a44509e7d83a475cd79c3cc52c6d197a3abb1614"
    sha256                               sonoma:        "2ee91edf310685045a1cabb9f0733d64ec5c5b1817398242c1330852245f75c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "539c0b59e9c5f0583d528aff99065541614c7b1d0c5eb59fc5032221e35613b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c86b22a22462df5e42907b2d83c3951e4373b365160ee733b1640702de777217"
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