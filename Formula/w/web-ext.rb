require "languagenode"

class WebExt < Formula
  desc "Command-line tool to help build, run, and test web extensions"
  homepage "https:github.commozillaweb-ext"
  url "https:registry.npmjs.orgweb-ext-web-ext-8.0.0.tgz"
  sha256 "3e92cf85b10a52e0625ee6ba3032f8e7afbcc6645e4ff2e6a40c9527b348bc46"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1f3b67f9943f8f4e7bf576a7b279a8d2d2b709c1d817af5237354c9ce1bdb451"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "95835ecca173cc78812728d6a2eab005a3f8a9415541357d4803b24918020b81"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6232c16050284e0ae13e3fde689b01d1dfa37ef859e7d4af72c938ca45229069"
    sha256 cellar: :any_skip_relocation, sonoma:         "492dd59592b60d396108e65964a972271bd4f731fb593f3d36ea5c25e9c6a0e9"
    sha256 cellar: :any_skip_relocation, ventura:        "4f1ce854bfcd6fe02d199f6de4c9490dedf7c11945246678bdb06d304c3af293"
    sha256 cellar: :any_skip_relocation, monterey:       "eead009eeb1213989a042dc7817e285a67f4876c25ae3405762a2c36731736e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b330061e307d179bdf43d2a3f6cd40acb16705f6d4093f6389096acd34202db"
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