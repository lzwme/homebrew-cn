class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-15.19.0.tgz"
  sha256 "907befa41673b0a7a0ddca2a5a8918f0175ccd207964962e9e5e390618eded6d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4656d2e2a410051af9700fc4a997379881fbfc8f52b174270c667ecc224afaa8"
    sha256 cellar: :any,                 arm64_sequoia: "b42302ae99daddbd35e685faea05fdbc2cf27d4b9b2a4277bce4a5df78a4462b"
    sha256 cellar: :any,                 arm64_sonoma:  "b42302ae99daddbd35e685faea05fdbc2cf27d4b9b2a4277bce4a5df78a4462b"
    sha256 cellar: :any,                 sonoma:        "0be8d6f1afcd74bb2376ce33b26e4ecd4a6a48ed4d4e9bed0a7028f76842c13c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54be8f5320cf2e4f63ec896f0feda05a2696704a9123eeb3499ae405e2f6062d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d54d8863b734d43e78ed5290c81f4b3ab8497960e6fbc330042f52c73c46463"
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