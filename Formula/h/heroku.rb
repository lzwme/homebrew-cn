class Heroku < Formula
  desc "CLI for Heroku"
  homepage "https://www.npmjs.com/package/heroku/"
  url "https://registry.npmjs.org/heroku/-/heroku-11.1.0.tgz"
  sha256 "49a054a1d374d51ee305f96e60c20886a80203e8ea71368cc4001af9478e85bc"
  license "ISC"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "701adea28cba71255d6ab948656eead6379c987007d7bf282359724082b8dc9e"
    sha256 cellar: :any,                 arm64_sequoia: "c9cba0fbe2259552850a73e5d2bf611b695c919de35cc48f95fe880503241d00"
    sha256 cellar: :any,                 arm64_sonoma:  "c9cba0fbe2259552850a73e5d2bf611b695c919de35cc48f95fe880503241d00"
    sha256 cellar: :any,                 sonoma:        "76014377abdd3ce3930bbfe8f0db6dd2c6fd01947daf0099734a29e8de68ca53"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a195a16c2b55392da0b580da51515e786ba7e237626cf5b4666a6f39b0c23316"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e01ccec1a892219bb67438fbc8e26c49272459c54d2af7d1af4adfa75e2c82dc"
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