class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-15.25.0.tgz"
  sha256 "8a0cfebc2f6a68233f38328e5e455202051113ed2a4f6ec1921882c44adbc428"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8c756628b8bd9704698d4113aee68cf065ad077396423621ce787deae691a6ac"
    sha256 cellar: :any, arm64_sequoia: "8c756628b8bd9704698d4113aee68cf065ad077396423621ce787deae691a6ac"
    sha256 cellar: :any, arm64_sonoma:  "8c756628b8bd9704698d4113aee68cf065ad077396423621ce787deae691a6ac"
    sha256 cellar: :any, sonoma:        "fd8f99791a1f192a9fe49e39bd943afd8e5761f8ce130671686a19cc20ca8adb"
    sha256 cellar: :any, arm64_linux:   "a1802d8d414537d3def6057016756f11c0b8e20e27e7f71f4683953410244a2f"
    sha256 cellar: :any, x86_64_linux:  "d109c430253d0d084e8276785eef0022863bca2247867aa81af4e3cf617dadb2"
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