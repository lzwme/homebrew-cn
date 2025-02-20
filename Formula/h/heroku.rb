class Heroku < Formula
  desc "CLI for Heroku"
  homepage "https://www.npmjs.com/package/heroku/"
  url "https://registry.npmjs.org/heroku/-/heroku-10.2.0.tgz"
  sha256 "95f7985f9e630be01487c7a71d5f2b4709e749008307ce79de7e3dbcc162a80b"
  license "ISC"

  bottle do
    sha256                               arm64_sequoia: "884d2045f5022246902aa376b907e392cc073976c29ce15baa952997a9406797"
    sha256                               arm64_sonoma:  "c8e2068bb3ead95b245810956e05e9925def2cd0c8650e699c0f08ccd4dab551"
    sha256                               arm64_ventura: "ce12145b93c7dfcb6b52520c38f871911bb9a7c6e590e0b26ce9fcc0341c6a23"
    sha256                               sonoma:        "c7e64ba4730944beb0c38a6a4e1b7916ccf01236eb9027672609224d32969328"
    sha256                               ventura:       "368dfb5389f007f3dcbbe09083685348591b0d4d3f9f70ade2f699b0b9519c7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afa1004b0ac723468c67e9357f5039e7b4d70b5ae3208f40e21ec169dc3716e9"
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