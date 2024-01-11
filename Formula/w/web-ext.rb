require "languagenode"

class WebExt < Formula
  desc "Command-line tool to help build, run, and test web extensions"
  homepage "https:github.commozillaweb-ext"
  url "https:registry.npmjs.orgweb-ext-web-ext-7.10.0.tgz"
  sha256 "70c506b4896740c74dbf35a1d82e5ff41c71e1cdc3b0cc1c78c568970a584680"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9709fbebb690f6df8ce94556e2a4c2282f11cb69cb4ccb2d0bb08412cd4d8fbd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7af05aceebff869acb91c04c3fb591db43b8912eadd06ed4fd8d32d7d9dbacb1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb9fd4b7f701ef0f940466c20c30e10f3bd57c587c9e75c2166c0541b6a8edc9"
    sha256 cellar: :any_skip_relocation, sonoma:         "f8c83ab881566d9f5620ca7d16dcb7959f84a24206b39e3874c634c05b75f32d"
    sha256 cellar: :any_skip_relocation, ventura:        "7f67b4feee170b7b6030ea5689e7256624c95f348f1599f10e85d5a59b9a33ad"
    sha256 cellar: :any_skip_relocation, monterey:       "f56e3d766e56cd1813a8836431ddc54ba3fd1f389a5bdde3ae92f13fe64c5430"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc1c712d9b9b2298934ccc345feb8d49d1b2b7386d35c4510267225a86a3443e"
  end

  depends_on "node"

  on_macos do
    depends_on "terminal-notifier"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]

    # Remove vendored pre-built binary `terminal-notifier`
    node_notifier_vendor_dir = libexec"libnode_modulesweb-extnode_modulesnode-notifiervendor"
    node_notifier_vendor_dir.rmtree # remove vendored pre-built binaries

    if OS.mac?
      terminal_notifier_dir = node_notifier_vendor_dir"mac.noindex"
      terminal_notifier_dir.mkpath

      # replace vendored `terminal-notifier` with our own
      terminal_notifier_app = Formula["terminal-notifier"].opt_prefix"terminal-notifier.app"
      ln_sf terminal_notifier_app.relative_path_from(terminal_notifier_dir), terminal_notifier_dir
    end
  end

  test do
    (testpath"manifest.json").write <<~EOF
      {
        "manifest_version": 2,
        "name": "minimal web extension",
        "version": "0.0.1"
      }
    EOF
    assert_equal <<~EOF, shell_output("#{bin}web-ext lint").gsub( +$, "")
      Validation Summary:

      errors          0
      notices         0
      warnings        0

    EOF

    assert_match version.to_s, shell_output("#{bin}web-ext --version")
  end
end