class Heroku < Formula
  desc "CLI for Heroku"
  homepage "https://www.npmjs.com/package/heroku/"
  url "https://registry.npmjs.org/heroku/-/heroku-10.0.1.tgz"
  sha256 "9766644e48dfd2a3da575d8f5c43178432c7645b66e039ded2950e6795ec71ec"
  license "ISC"

  bottle do
    sha256                               arm64_sequoia: "89f4d175b11afe196eb8058c1264c79660cb416d5390ae4fa0fc1f1dbf66954a"
    sha256                               arm64_sonoma:  "18c516f6a27e889af498f8f6c14d2367457bcd0a80adbfe2700705e7e90d68b2"
    sha256                               arm64_ventura: "5fcd855595f79c6741078b3d46b1eac44c89257f10614d27e03be18bec6ae2c8"
    sha256                               sonoma:        "c1002d557f5954709e6bebdeec0226eaf5858bb2cc41bc4ae68a24446a8c9819"
    sha256                               ventura:       "1ef1453616259ca928b65396863fc576d0b0dba8900b3b80a613050608f5c90c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6db69ab1ea1ccc2eeae2fa10dc4c7399dd134e62d55ae24111bd394dba4fbfb7"
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