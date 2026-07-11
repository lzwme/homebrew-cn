class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-15.23.0.tgz"
  sha256 "d9e63777eb6351161d8660805986eb07f98d2838b36f528a75a2ff01ab3b4ee7"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f16a7fa567eae254b531250e2a1c3a16d48da342679e3767ebc7bf71222f7bc7"
    sha256 cellar: :any, arm64_sequoia: "2c69c047c1d6261b594a7e607816a56afb0bca3fe6d847b786ea47234446f7eb"
    sha256 cellar: :any, arm64_sonoma:  "2c69c047c1d6261b594a7e607816a56afb0bca3fe6d847b786ea47234446f7eb"
    sha256 cellar: :any, sonoma:        "e945b5dca99d7f99ad43e056dd2f5f242c3b93c544bdbf31b8cc56d3a3b795d5"
    sha256 cellar: :any, arm64_linux:   "16b799e1ab9e65a06e0abd8eef48e924e4b8a99fa913e567967c546a754e4564"
    sha256 cellar: :any, x86_64_linux:  "3a39d853147f18ada7f4d0aac1254c5246cac0bb373001875c96398069b340ac"
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