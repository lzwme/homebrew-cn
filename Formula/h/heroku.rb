class Heroku < Formula
  desc "CLI for Heroku"
  homepage "https://www.npmjs.com/package/heroku/"
  url "https://registry.npmjs.org/heroku/-/heroku-11.6.0.tgz"
  sha256 "a008537a5a172f777c18279d4b517483438f4e6e3e16917afb7416f181002029"
  license "ISC"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "67c6b174737dbc0d827f1ec5b57e1a909950f0eaab95be0e261e1f4a7e9e375a"
    sha256 cellar: :any, arm64_sequoia: "f7c3832091e8f717653125712c403fa6aaec79b040ab877c17440714c58d4a83"
    sha256 cellar: :any, arm64_sonoma:  "f7c3832091e8f717653125712c403fa6aaec79b040ab877c17440714c58d4a83"
    sha256 cellar: :any, sonoma:        "74a5c259380eb6fff718956165906b717d605ca14c1d6c5d56ccab55a9faa83b"
    sha256 cellar: :any, arm64_linux:   "e94b5a7b5d1ad822cb6675b7d09f24c6b6fbb85fa2aa076dd4fe7fca81e7bcb4"
    sha256 cellar: :any, x86_64_linux:  "fba2fc70537efe4ddc6dc72590453e5f2004bfabc7a8b2b921bba841e20c4b5b"
  end

  depends_on "node"

  on_macos do
    depends_on "terminal-notifier"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/heroku/node_modules"
    # Remove vendored pre-built binary `terminal-notifier`
    node_notifier_vendor_dir = node_modules/"node-notifier/vendor"
    rm_r(node_notifier_vendor_dir) # remove vendored pre-built binaries

    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

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