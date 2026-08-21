class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-15.28.0.tgz"
  sha256 "ba436b53ade0370a0980ae38142f15d20eb2beb7ae2d07e476298d2d210b131e"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "cae1ccb0913a153a0ad508ed74fee00059d773f7899b45b194f826f22738a76a"
    sha256 cellar: :any, arm64_sequoia: "cae1ccb0913a153a0ad508ed74fee00059d773f7899b45b194f826f22738a76a"
    sha256 cellar: :any, arm64_sonoma:  "cae1ccb0913a153a0ad508ed74fee00059d773f7899b45b194f826f22738a76a"
    sha256 cellar: :any, sonoma:        "0582dfc734f5fe061bc42d70ce9e95ec0320cd1a0d570a256fa7c560353ae4db"
    sha256 cellar: :any, arm64_linux:   "844fca92c55f4c703d1cdb5c7ca28eb6066158f2829b7661e69a0e79cf630e12"
    sha256 cellar: :any, x86_64_linux:  "baabeafc3c1ae778c1ce679af91750e854336834b9ceef4ea66b93d70c562f25"
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