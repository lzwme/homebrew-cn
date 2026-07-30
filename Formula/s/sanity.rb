class Sanity < Formula
  desc "Command-line interface for Sanity"
  homepage "https://www.sanity.io/"
  url "https://registry.npmjs.org/@sanity/cli/-/cli-7.14.0.tgz"
  sha256 "11f4a8d29901010ab51b694d531bdd50ac4f15e632346ecb8bacb4532644c1b6"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "09e1897278901c1acacfa977481bb7e1515c4420c23189109e5697371d0711e8"
    sha256 cellar: :any, arm64_sequoia: "09e1897278901c1acacfa977481bb7e1515c4420c23189109e5697371d0711e8"
    sha256 cellar: :any, arm64_sonoma:  "09e1897278901c1acacfa977481bb7e1515c4420c23189109e5697371d0711e8"
    sha256 cellar: :any, sonoma:        "a2e25d49a0944f6a8c1451f651772c413c0f12f989190e2a833d96d4962923c4"
    sha256 cellar: :any, arm64_linux:   "e467ae36800475b15cd84476def50950b148bfd28160e26dc678ac3933b79241"
    sha256 cellar: :any, x86_64_linux:  "ad48d3d48541c8701cda08575d4ba96d7d93aec70961961f9b591aa9c1cc36d1"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@sanity/cli/node_modules"
    # Remove incompatible pre-built `bare-fs`/`bare-path`/`bare-os`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-path,bare-os,bare-url}/prebuilds/*")
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