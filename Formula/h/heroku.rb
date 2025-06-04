class Heroku < Formula
  desc "CLI for Heroku"
  homepage "https://www.npmjs.com/package/heroku/"
  url "https://registry.npmjs.org/heroku/-/heroku-10.9.0.tgz"
  sha256 "6d7f0cc307a2df2e47d5f8f667bb09becfb3a89e6b9ffb29c98c6aeb285f89ad"
  license "ISC"

  bottle do
    sha256                               arm64_sequoia: "72566d7f7a37c98e676fbffeb4c20354d0b1a38aa7700647a2c66afe51a1d048"
    sha256                               arm64_sonoma:  "367a623cca2fde392f240b05db6c822118e73e956b64e5021b62d91601cc5b48"
    sha256                               arm64_ventura: "9170f05aee2231849fed727ded7394723029979fccb940540ccfb06bf4e30310"
    sha256                               sonoma:        "aa1a95f2a736679998494b62569040d566a5052f5c7c2eb01ce12aa9a4cc0e8d"
    sha256                               ventura:       "2f2c412edbccc64a65041324e9ddf2bfe33f985ecdad97ac142b78ef793f5e59"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32bc21b8bc283584e178946d85237be4971ee9449737d6b8ba8bf235fb4c89d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b7d5fbff47da17bc0282d256043b1391f05e1296d672011523100f4f3d4c89f"
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