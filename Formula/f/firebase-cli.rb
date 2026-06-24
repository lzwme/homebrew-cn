class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-15.22.1.tgz"
  sha256 "2efcc8d9414da37e40fcfbb93a3b65e48e16f80a345d1e53671aaba8ada2ae33"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d6fea38a32add99cf377b4c5841e705f6efe51abdde0558a35a7caa71c82b905"
    sha256 cellar: :any, arm64_sequoia: "c8d053e5a65ddd303c3328dad88bf16c35615b496be5560d2096828683556fd6"
    sha256 cellar: :any, arm64_sonoma:  "c8d053e5a65ddd303c3328dad88bf16c35615b496be5560d2096828683556fd6"
    sha256 cellar: :any, sonoma:        "f6b1f2b7e50aed48333714d55468299840d6df2fcc596c5b35c18933d5d14169"
    sha256 cellar: :any, arm64_linux:   "2e2bad273225fc45e772273c2c9a6ab0d7576f0bc1d0b193a090dc803b9f5c08"
    sha256 cellar: :any, x86_64_linux:  "bd8fbf5ffdd325565c8c02d2e51efb0d932c8fe5c3724f9ccd9baf6b405fc029"
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