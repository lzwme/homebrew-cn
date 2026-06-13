class Heroku < Formula
  desc "CLI for Heroku"
  homepage "https://www.npmjs.com/package/heroku/"
  url "https://registry.npmjs.org/heroku/-/heroku-11.5.0.tgz"
  sha256 "9cb8847462256e60b0e480867b00665ac50ea6ffa31fd21b71e215a369a620cb"
  license "ISC"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4cb356e94f96142f53ecfc2abbe3fc56ead5532b305c4f0dc42d9ef5512c1d70"
    sha256 cellar: :any, arm64_sequoia: "f050ebc8a963e6f18d115ace801350af796ccf0dc5ac4774327b76a32c2bb062"
    sha256 cellar: :any, arm64_sonoma:  "f050ebc8a963e6f18d115ace801350af796ccf0dc5ac4774327b76a32c2bb062"
    sha256 cellar: :any, sonoma:        "42657b94c4f7a8c392ff1cc5fabe94177b13cb36927cfbe6b59d27886fe69d2f"
    sha256 cellar: :any, arm64_linux:   "aa5fa3b5d56116d414bed153733fe266554c4aaacef298941bd9e77d718206a0"
    sha256 cellar: :any, x86_64_linux:  "2290269c4f8149dc8a47dc20769b7f3f92476d09a5ddb3ced2e08db1f9a06e62"
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