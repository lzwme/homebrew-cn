class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://registry.npmjs.org/appwrite-cli/-/appwrite-cli-19.1.0.tgz"
  sha256 "5fdbe806046ece8c93894277bd50291ec7caebdece2867ee8248d9fd14817271"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6be504c2914ee1809a5a72096e14f4232d7f15e25ff449e2242b1b98d0ee07bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3bdd2d0a5ab62a6690cdb06177555326955b840e9c0f53602307f70fd7148140"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3bdd2d0a5ab62a6690cdb06177555326955b840e9c0f53602307f70fd7148140"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c11c0376219241ba7f14c474ffd2c5d562e959951db41d82cf742542853b830"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97aa8c93ab35050dc6279db8db5eb6cbd210cb70f9bdf5ad91581aebbdd3f439"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97aa8c93ab35050dc6279db8db5eb6cbd210cb70f9bdf5ad91581aebbdd3f439"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/appwrite-cli/node_modules"
    machos = %w[fsevents/fsevents.node app-path/main]
    machos.each { |macho| deuniversalize_machos node_modules/macho } if OS.mac?
  end

  test do
    output = shell_output("#{bin}/appwrite client --endpoint http://localhost/v1 2>&1", 1)
    assert_match "Error: Invalid endpoint", output

    assert_match version.to_s, shell_output("#{bin}/appwrite --version")
  end
end