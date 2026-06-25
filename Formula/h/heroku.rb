class Heroku < Formula
  desc "CLI for Heroku"
  homepage "https://www.npmjs.com/package/heroku/"
  url "https://registry.npmjs.org/heroku/-/heroku-11.7.0.tgz"
  sha256 "8ff96c76f5287bb0563f7fde4b64ccb5bfc1e8510160b19202a6c312dd4bbda2"
  license "ISC"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b4539497838da19f28b0465d04fcd241d2f767974e0e1cac2f43d4d1b4471ef2"
    sha256 cellar: :any, arm64_sequoia: "d039c8dd75b39b2037cec1094e7a02f311a69c6d7111fcf879a4cb59a23480c3"
    sha256 cellar: :any, arm64_sonoma:  "d039c8dd75b39b2037cec1094e7a02f311a69c6d7111fcf879a4cb59a23480c3"
    sha256 cellar: :any, sonoma:        "4ae522721b239982eb7881c5601bbb08ffac76aeac701b2fae9f0c00ddb103f6"
    sha256 cellar: :any, arm64_linux:   "46b9a12b654d3b08ddb5e40f91ef02712296ffbd26c059859e5403650793569c"
    sha256 cellar: :any, x86_64_linux:  "3b33d251acf4c7b6cfcba13b5682b71dc782fcf90b421dae02af4af0cb0ee152"
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
      terminal_notifier_app = formula_opt_prefix("terminal-notifier")/"terminal-notifier.app"
      ln_sf terminal_notifier_app.relative_path_from(terminal_notifier_dir), terminal_notifier_dir
    end

    # Replace universal binaries with their native slices.
    deuniversalize_machos
  end

  test do
    assert_match "Error: not logged in", shell_output("#{bin}/heroku auth:whoami 2>&1", 100)
  end
end