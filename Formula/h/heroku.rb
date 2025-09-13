class Heroku < Formula
  desc "CLI for Heroku"
  homepage "https://www.npmjs.com/package/heroku/"
  url "https://registry.npmjs.org/heroku/-/heroku-10.13.1.tgz"
  sha256 "cd7d67c91d46df28c757469d65fcff5940328f9d12a282f34123af3ce1d1bd10"
  license "ISC"

  bottle do
    sha256                               arm64_tahoe:   "84404cdf40d0d4c878ac1034317d1ed90949601ce700cb73671a75a16bfc5c78"
    sha256                               arm64_sequoia: "4c5ae4565320f80478ee2aa54bdb582be65879e2fdbbe916b334bd2143e29d82"
    sha256                               arm64_sonoma:  "5b383d6a19d5a23997b5be5b565fc05ed160021b60129e52af419d5e98c9de12"
    sha256                               arm64_ventura: "3660c6c8bb2d0b8ab37cfb2fff59eb970132c7596ff4cf050d14f5b6c7aa7b6f"
    sha256                               sonoma:        "a9cd6c1f76db642dc696fe524c0728e23822410ad37913e25b6baf989502d76b"
    sha256                               ventura:       "b03202ed074d70a5843b26becbe8b370f7492dbc17ab47d1d10c354cfc4134b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e96a62ac13710dded6b68e0646bacd7c5a0daacbd17f3956c8532b87174cd5f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73114bed6ae557b41495e1ec29983a9bf9fa55de79eaea21c7e9a84651c23ca5"
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