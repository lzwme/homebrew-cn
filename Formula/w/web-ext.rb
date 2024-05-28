require "languagenode"

class WebExt < Formula
  desc "Command-line tool to help build, run, and test web extensions"
  homepage "https:github.commozillaweb-ext"
  url "https:registry.npmjs.orgweb-ext-web-ext-7.12.0.tgz"
  sha256 "d4e26ceb573bed831ea9165fcbfa2cb42bcba19a797204649fe526d2a38bb2ef"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8b5909016299c2a6113aa1672a4a20a3139286f74f805ba5921bab3413b1dbe5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ada802911bd52519e20ed69b6a3e30cc8015c51a4666c1283580bd05fa19d01"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc70496a8e1e16f9a3f6c8f3455792dd710591be461c9f7302abf25b5a734635"
    sha256 cellar: :any_skip_relocation, sonoma:         "91ea59bd1149b0616e414c71629d0ce8b946d5feadfb7ed6d5b66c196409854b"
    sha256 cellar: :any_skip_relocation, ventura:        "4b0c3eb792da7eacad4c56ed6d4b659819f9515d7d405e5e0a63b1704568d18b"
    sha256 cellar: :any_skip_relocation, monterey:       "988d9a322a39e7dc128e3119367c90e0e42ef5c37b25813888cfe115c868a8f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65c5e91927dd61e3d8940b998cbac251a0a5f95871a5a22fc893faeb9a61dde9"
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