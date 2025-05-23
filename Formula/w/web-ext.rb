class WebExt < Formula
  desc "Command-line tool to help build, run, and test web extensions"
  homepage "https:github.commozillaweb-ext"
  url "https:registry.npmjs.orgweb-ext-web-ext-8.7.0.tgz"
  sha256 "19301015ae593ab449324884f211c5f353440261448d3569c353716347f08aaf"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b92710b9e7b00d0c0040b04e0eab2223fc20487f6777e36d6616322702bcb128"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b92710b9e7b00d0c0040b04e0eab2223fc20487f6777e36d6616322702bcb128"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b92710b9e7b00d0c0040b04e0eab2223fc20487f6777e36d6616322702bcb128"
    sha256 cellar: :any_skip_relocation, sonoma:        "43542fa43090f951b422c59e721cb4fffc76ef86f65eb4206a72e0f3b3f9d93f"
    sha256 cellar: :any_skip_relocation, ventura:       "43542fa43090f951b422c59e721cb4fffc76ef86f65eb4206a72e0f3b3f9d93f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ccdffe61cd6b00b8978fb25fc56466d926de50f9e6a073da28c6d20c158a1154"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ccdffe61cd6b00b8978fb25fc56466d926de50f9e6a073da28c6d20c158a1154"
  end

  depends_on "node"

  on_macos do
    depends_on "terminal-notifier"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]

    # Remove vendored pre-built binary `terminal-notifier`
    node_notifier_vendor_dir = libexec"libnode_modulesweb-extnode_modulesnode-notifiervendor"
    rm_r(node_notifier_vendor_dir) # remove vendored pre-built binaries

    if OS.mac?
      terminal_notifier_dir = node_notifier_vendor_dir"mac.noindex"
      terminal_notifier_dir.mkpath

      # replace vendored `terminal-notifier` with our own
      terminal_notifier_app = Formula["terminal-notifier"].opt_prefix"terminal-notifier.app"
      ln_sf terminal_notifier_app.relative_path_from(terminal_notifier_dir), terminal_notifier_dir
    end
  end

  test do
    (testpath"manifest.json").write <<~JSON
      {
        "manifest_version": 2,
        "name": "minimal web extension",
        "version": "0.0.1"
      }
    JSON
    assert_equal <<~EOF, shell_output("#{bin}web-ext lint").gsub( +$, "")
      Validation Summary:

      errors          0
      notices         0
      warnings        0

    EOF

    assert_match version.to_s, shell_output("#{bin}web-ext --version")
  end
end