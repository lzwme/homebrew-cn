class Heroku < Formula
  desc "CLI for Heroku"
  homepage "https://www.npmjs.com/package/heroku/"
  url "https://registry.npmjs.org/heroku/-/heroku-10.10.1.tgz"
  sha256 "1a7bd82790a94739d70601ebdc5b60c02459bc7c9a7e4c13f28444993bfd2347"
  license "ISC"

  bottle do
    sha256                               arm64_sequoia: "895ff9a3e28f1923edacfec1e0603c596e414980bf66f1bfb7edfccbc9b21e3b"
    sha256                               arm64_sonoma:  "e7500e1903340af71da2abc9338e3706ca5707a690b248acfd60f0e7bdae87d8"
    sha256                               arm64_ventura: "b302e754c01f956239cef2f505276d544c1434dc7e7660b8be48f1fd2dd3d4fe"
    sha256                               sonoma:        "d5f4f1efa3d184a44776bbfa9088d3e6dc8f214112d8bc1198ebec5b8c7aef83"
    sha256                               ventura:       "10e308db7f3cd61798ccb01662154b8dac1a7994a9f5ace5dc7c244dbcfac7a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b85d1bc9886ccfea6c3c4079ca86b47cb5fe2d8c0e146376a1bcc37af44ca5b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc982c139a6e266a46c70f1423a5a3df4f8784e86ab679eca07eee54e795b008"
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