class WebExt < Formula
  desc "Command-line tool to help build, run, and test web extensions"
  homepage "https://github.com/mozilla/web-ext"
  url "https://registry.npmjs.org/web-ext/-/web-ext-9.4.0.tgz"
  sha256 "4e4aba47e0f79c0b6b396797c30075efd20609f10310111b2bb76f9cf08804aa"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9e345e1a320cb57cff6c7f78f7d233b10f231d3a9bfdca1e9e971bb7215e6cca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e345e1a320cb57cff6c7f78f7d233b10f231d3a9bfdca1e9e971bb7215e6cca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e345e1a320cb57cff6c7f78f7d233b10f231d3a9bfdca1e9e971bb7215e6cca"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e345e1a320cb57cff6c7f78f7d233b10f231d3a9bfdca1e9e971bb7215e6cca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57f04c57e5925120c038f5def15491102bb5b3fc9ea99c3a5063c25d245bf052"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57f04c57e5925120c038f5def15491102bb5b3fc9ea99c3a5063c25d245bf052"
  end

  depends_on "node"

  on_macos do
    depends_on "terminal-notifier"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove vendored pre-built binary `terminal-notifier`
    node_notifier_vendor_dir = libexec/"lib/node_modules/web-ext/node_modules/node-notifier/vendor"
    rm_r(node_notifier_vendor_dir) # remove vendored pre-built binaries

    if OS.mac?
      terminal_notifier_dir = node_notifier_vendor_dir/"mac.noindex"
      terminal_notifier_dir.mkpath

      # replace vendored `terminal-notifier` with our own
      terminal_notifier_app = Formula["terminal-notifier"].opt_prefix/"terminal-notifier.app"
      ln_sf terminal_notifier_app.relative_path_from(terminal_notifier_dir), terminal_notifier_dir
    end
  end

  test do
    (testpath/"manifest.json").write <<~JSON
      {
        "manifest_version": 2,
        "name": "minimal web extension",
        "version": "0.0.1"
      }
    JSON
    assert_match <<~EOF, shell_output("#{bin}/web-ext lint").gsub(/ +$/, "")
      Validation Summary:

      errors          0
      notices         0
      warnings        2

    EOF

    assert_match version.to_s, shell_output("#{bin}/web-ext --version")
  end
end