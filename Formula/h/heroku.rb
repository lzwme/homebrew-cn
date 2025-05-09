class Heroku < Formula
  desc "CLI for Heroku"
  homepage "https://www.npmjs.com/package/heroku/"
  url "https://registry.npmjs.org/heroku/-/heroku-10.7.0.tgz"
  sha256 "518e73915bd2134e68ccd04741a0f790f35847dc39951b3edc27cd634e37550f"
  license "ISC"

  bottle do
    sha256                               arm64_sequoia: "ba167e543e9529e78ce6c7106c32678f24ad0d59b5f9af0bd959db047f99b0e3"
    sha256                               arm64_sonoma:  "dafe1bae56a7f0a43f512032b794a04d4d96ec64b824d4d1e7f5405cc5d0c4ab"
    sha256                               arm64_ventura: "53bd059bf3d2a323e4b5c2e63b7d3d621a1f9d5b64a486b2aba33f18460547f3"
    sha256                               sonoma:        "48041780138edd9a4868f848838fd7642b695c8d4ba63a58b580169c8596fa6b"
    sha256                               ventura:       "ed5b029b88e298d35add4198f4086cb7dfe1676ff1ce188976a1370126a45c88"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4b8f063121a6735395a5d0dbd3d42fb56c569daa993dee84cb0a80cd1eade73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8dd0f9a00e54e78e28a19f3b38f53fe255a769c853ba50b99f35c5966b5c64b"
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