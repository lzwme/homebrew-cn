class Heroku < Formula
  desc "CLI for Heroku"
  homepage "https://www.npmjs.com/package/heroku/"
  url "https://registry.npmjs.org/heroku/-/heroku-10.3.0.tgz"
  sha256 "12542c4a0535e3cd738e24b5a6e6f827960463032825d86f34b154de5af49da4"
  license "ISC"

  bottle do
    sha256                               arm64_sequoia: "7c6ef38ee7f01666bc76a529c6052e5a55a8aa7dac8656243d9844e2f7462127"
    sha256                               arm64_sonoma:  "d4fcd93549a77697d04c731e7499925d38b238535fd657faf4e3c67df4f7f78f"
    sha256                               arm64_ventura: "dabcf3bbb29e3c9a47054703ca47dc6cb862def4f7169fc6617088e26a863a4a"
    sha256                               sonoma:        "f2a8c5b9c4425625b4da3d2deea2bf9801a83e36fc9ce319d0b107e4aa1150f3"
    sha256                               ventura:       "bffc6a269036ab35a0180d61605b9a3860e3cd611ca2423b086063a31b8a3161"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4af501d294858d3d00772dd08e6673a91d1a87818a0a4115fbd012521c286de4"
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