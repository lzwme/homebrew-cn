class Heroku < Formula
  desc "CLI for Heroku"
  homepage "https://www.npmjs.com/package/heroku/"
  url "https://registry.npmjs.org/heroku/-/heroku-10.4.0.tgz"
  sha256 "8d4d267dc35fc5d63f01359568e3e74e7d294bd167e0c1e47130d271a80e9a41"
  license "ISC"

  bottle do
    sha256                               arm64_sequoia: "b892e79a050c885237721a265eec6d521f20357e291f412e06181d060baede3e"
    sha256                               arm64_sonoma:  "850e1c761df2a2dfc3af565a4d2c074ab362a84fb6594b4e44ac7811842d2aa6"
    sha256                               arm64_ventura: "558e1b57ebabf4751e618d9448693c3fa546290d0f1e29e4240638e0a4551609"
    sha256                               sonoma:        "2fe26d6655fa4017278817a577e2bff13e1e3d87ce7b4550bbf70e6eb1798f17"
    sha256                               ventura:       "4bacec0ff9f06d4ab62be169ae6a74cdfa69c216e125e93cc146e78233abb28e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd055c3defdc2253ab437d8486f3c87117eac264e0ed8f233a352c0e1f419d87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16edadacb414c621e709f72289b139e85e42ab368268af6a05f92ec1425257ee"
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