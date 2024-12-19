class Heroku < Formula
  desc "CLI for Heroku"
  homepage "https://www.npmjs.com/package/heroku/"
  url "https://registry.npmjs.org/heroku/-/heroku-10.0.0.tgz"
  sha256 "7c6b4606401ef9fc5a44e70eaabe1c0e1b920715f2a87cba480db244065ee23f"
  license "ISC"

  bottle do
    sha256                               arm64_sequoia: "f8b37011ec559293cb57aac84381198543517e7d98667f4acc004d159d51ae69"
    sha256                               arm64_sonoma:  "2e3441ed20936529c1f3bffd473a129e41987b9c10a251cc49f7f32cd8fc69e6"
    sha256                               arm64_ventura: "ce0c5785bfb824b8a80e72cf4176edee4312e43592bf008bcbc5f2583618cf51"
    sha256                               sonoma:        "38f8955a25884a3cce6eefabcfb712b6738117f980b8072ae7cc1417abd4a060"
    sha256                               ventura:       "83b2c2ce6f46563fac34fd0dca688609ac6f0d501b0d937b3ffa44dec753ec89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09053cead03a15ab4bbd4a4d06d3ec9927af074001187b35081650980068f5fb"
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