class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-15.25.1.tgz"
  sha256 "3517effab3f6c869934da9836a43db6683213e7431c9ef6f3f4b7b349f058bd4"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e69661a1458c1107faa6425940500d9d5ab5e550b00e646f507515566de89c88"
    sha256 cellar: :any, arm64_sequoia: "e69661a1458c1107faa6425940500d9d5ab5e550b00e646f507515566de89c88"
    sha256 cellar: :any, arm64_sonoma:  "e69661a1458c1107faa6425940500d9d5ab5e550b00e646f507515566de89c88"
    sha256 cellar: :any, sonoma:        "b6841ac9b9e5165489cd4dc4d216de4cddf5b422b1a4c13be9136864ded9d64d"
    sha256 cellar: :any, arm64_linux:   "ed351ed9c24d0b7cd0988a4ccdb26a8743c80fd94cf2aaebba36cfb235e4f244"
    sha256 cellar: :any, x86_64_linux:  "78f176c9a852f1a47dcdb80c72644851cc3b37dad3a6424e9373011f0cc88231"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/firebase-tools/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?

    # Remove incompatible pre-built `bare-fs`/`bare-path`/`bare-os`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-path,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/firebase --version")

    assert_match "Failed to authenticate", shell_output("#{bin}/firebase projects:list", 1)
  end
end