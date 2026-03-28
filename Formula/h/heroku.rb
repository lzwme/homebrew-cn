class Heroku < Formula
  desc "CLI for Heroku"
  homepage "https://www.npmjs.com/package/heroku/"
  url "https://registry.npmjs.org/heroku/-/heroku-11.0.2.tgz"
  sha256 "d3d950dc4bed0f9bc4e9874553d9990e32da0855d92d9afb8690a5ca59fc514f"
  license "ISC"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c893f554da04211cce57815105fb49cfefa054ffdcf1c7b1b4fccbf8e474b55d"
    sha256 cellar: :any,                 arm64_sequoia: "f6f6f7da2ad1d0cac8bda6b6d055983e5d34a9cfb6e65b5d1fb8cfba9e033165"
    sha256 cellar: :any,                 arm64_sonoma:  "f6f6f7da2ad1d0cac8bda6b6d055983e5d34a9cfb6e65b5d1fb8cfba9e033165"
    sha256 cellar: :any,                 sonoma:        "f39cc2642bddb0158d4bd89b5f9c8a77a85af68d53252f23ed7fcccc17e5d6cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "982293848c5b65ad354279148248ca8b78c45e1d93b36beaf3695bc8488394a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4d9eb06e680c6bcf8f9c5c5ac1ab6580a319e7d3a4c0729f55e3f88c50e7492"
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