class Heroku < Formula
  desc "CLI for Heroku"
  homepage "https://www.npmjs.com/package/heroku/"
  url "https://registry.npmjs.org/heroku/-/heroku-11.1.1.tgz"
  sha256 "a44d72584c935c24aebd4eb501d4597a15e1045189a70fe493351a72f8100e9f"
  license "ISC"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f7f2cd2bef8323dcca2fa4d40eb7537acc5b7dba498cf0a50124822573434a6f"
    sha256 cellar: :any,                 arm64_sequoia: "6c19ab8465f6d485c1694eddc8512d2577b9a4bc1176775b1875a9f1f386c389"
    sha256 cellar: :any,                 arm64_sonoma:  "6c19ab8465f6d485c1694eddc8512d2577b9a4bc1176775b1875a9f1f386c389"
    sha256 cellar: :any,                 sonoma:        "3f3950b0d972709570e1154d3819abeecbc93b7d0ec368be69d0c45d34b1b38b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c00e9641a64bb6682fcb6317210150df2e4d1298ddbe36eec9764e345a44231"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cdf79851c65e33b143bb5b540fbe51f1c240c84abfa7d611cbdd9983fd313e3e"
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