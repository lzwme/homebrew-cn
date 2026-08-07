class Heroku < Formula
  desc "CLI for Heroku"
  homepage "https://www.npmjs.com/package/heroku/"
  url "https://registry.npmjs.org/heroku/-/heroku-11.9.0.tgz"
  sha256 "8ad9a383562eb0cb56fc8882db4507eef5aae8475299f2a198d4b1bf7e7cb4a5"
  license "ISC"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "491c41b06dc3451393cad7bd83421d69001c2f9bcd1a484645edeb9592b8158d"
    sha256 cellar: :any, arm64_sequoia: "491c41b06dc3451393cad7bd83421d69001c2f9bcd1a484645edeb9592b8158d"
    sha256 cellar: :any, arm64_sonoma:  "491c41b06dc3451393cad7bd83421d69001c2f9bcd1a484645edeb9592b8158d"
    sha256 cellar: :any, sonoma:        "9111b915cbbce6b62fde3a652da00f6765a616cbad11e3240fdddfc187d24de2"
    sha256 cellar: :any, arm64_linux:   "b365a0c6203b6a84a6b3da6ac574faac76c3f62ad7d79f9203c89deb4d42fc3a"
    sha256 cellar: :any, x86_64_linux:  "46b559671cdd8e9c7746044abbc46ac083b6c2d611f99443ddd8f05cf5f5cad4"
  end

  depends_on "node"

  on_macos do
    depends_on "terminal-notifier"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/heroku/node_modules"

    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-path,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    # Replace universal binaries with their native slices.
    deuniversalize_machos
  end

  test do
    assert_match "Error: not logged in", shell_output("#{bin}/heroku auth:whoami 2>&1", 100)
  end
end