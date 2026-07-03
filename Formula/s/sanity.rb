class Sanity < Formula
  desc "Command-line interface for Sanity"
  homepage "https://www.sanity.io/"
  url "https://registry.npmjs.org/@sanity/cli/-/cli-7.5.0.tgz"
  sha256 "25a0202694287f7d99ba6539da9b8b310d0163cdbe784b21ab759916e738e674"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b9fa9a2c90096b7991053e6d5b4478d9fc345563b4168b8c1b2fdbd7bd6801b0"
    sha256 cellar: :any, arm64_sequoia: "5a11674d794d47419af46fc2a5a71393d09772888d538aeb43f20ff8f4acffb2"
    sha256 cellar: :any, arm64_sonoma:  "5a11674d794d47419af46fc2a5a71393d09772888d538aeb43f20ff8f4acffb2"
    sha256 cellar: :any, sonoma:        "6964f010c5fa76f68251bdb6e0483ecae9b9a7c66ecf4c5ca1fbc19edaf17ff2"
    sha256 cellar: :any, arm64_linux:   "c0bee565c21623f6b5229a3e952353a7ab5af7732748b5406eb8394129beea16"
    sha256 cellar: :any, x86_64_linux:  "8f3996f5512147581748239a26d3815b8e2b967562b2965b0668d62b750e75c6"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@sanity/cli/node_modules"
    # Remove incompatible pre-built `bare-fs`/`bare-os`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    ENV["HOME"] = testpath
    ENV["CI"] = "1"
    ENV.delete "SANITY_AUTH_TOKEN"

    output = shell_output("#{bin}/sanity debug")
    assert_match "Not logged in", output
    assert_match "No project found", output
  end
end