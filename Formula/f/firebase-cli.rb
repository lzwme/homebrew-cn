class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-15.9.0.tgz"
  sha256 "29299b0da525754a1e557e8ca8d6e0f5fab1a7c69ffae0143509c3349f60e515"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6ad84489155af06d17101ab449436fdc176a54c625a898b7a05d25bd8e2d2b86"
    sha256 cellar: :any,                 arm64_sequoia: "84dd69059889218e08122793fab4aff4c73810cc13e38db62bc216c48d9a11d0"
    sha256 cellar: :any,                 arm64_sonoma:  "84dd69059889218e08122793fab4aff4c73810cc13e38db62bc216c48d9a11d0"
    sha256 cellar: :any,                 sonoma:        "177880606435e3a972d793099ed83dd2be9390533c71a831a25cb037e984cec8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95ec311c87241645a79757ce9c82c6aa134997ff0bbfed03edd2170520d4c4a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90c5c08de009241353664ce1af4d450cd7e294ba501a9b79362a0b9a8002e7da"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/firebase-tools/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?

    # Remove incompatible pre-built `bare-fs`/`bare-os`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/firebase --version")

    assert_match "Failed to authenticate", shell_output("#{bin}/firebase projects:list", 1)
  end
end