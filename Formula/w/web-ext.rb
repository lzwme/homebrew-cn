require "languagenode"

class WebExt < Formula
  desc "Command-line tool to help build, run, and test web extensions"
  homepage "https:github.commozillaweb-ext"
  url "https:registry.npmjs.orgweb-ext-web-ext-7.9.0.tgz"
  sha256 "d38d5b3efdbf7acc9278cb89246f79feb998aa53fe3ed8c4cdbb9707e4e22f3e"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4f2de60924078de5094f9df0e14d31939b8b61be2c0cbf31531d26fff6dbc698"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c2e7ba36b0819e4bc61917170b8ec468782dd3fbd904d2b5869e4733d8eacb3f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c134d5ebc355567abacd35f513926d50e8a2c27772255382bc7eeb57f8dfb20"
    sha256 cellar: :any_skip_relocation, ventura:        "f579744600234ba5ba58eb6a589914e5d43b35a75b54b4d06359b13e9f967c92"
    sha256 cellar: :any_skip_relocation, monterey:       "18835a263db5af99e31ba2bbea30a53325b4d2926d714ae40272d666ed0d7702"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "014791b1006dd3b498658bb25a8cdfb3d34b296d93e6be75e2186fca1bb43f16"
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