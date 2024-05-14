require "language/node"

class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-8.1.3.tgz"
  sha256 "1af740d44c04badf4ce1c9bddab9a4df4ae3053075a1e41904643cbbc6a01909"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2e4e73282d554cd7106b152905e73fca933e5e5cdf9d563fe8cd8c8790edf71f"
    sha256 cellar: :any,                 arm64_ventura:  "c73e8d7c61cb465ebc183e6a228173e0ef3c5e9125e6d088714a915652a7f41b"
    sha256 cellar: :any,                 arm64_monterey: "e650bbc35fc4b46c44218866344788b337ef93888c63ff00f357281f97490539"
    sha256 cellar: :any,                 sonoma:         "40af4183cd7593dcde89436884d4c83e83ad054c2518e59636092817995f4c22"
    sha256 cellar: :any,                 ventura:        "c9c8c68f2ca4efb8c350f89f237f30f04e0dd6456796d6971dbe25f483b5ef9b"
    sha256 cellar: :any,                 monterey:       "fc681e366796f3fa2493ded8258444ef72a22d5c4bc2bf90a8f635b6c8b1e65c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f3b3d3284abf0017e231f8bb5da17fdf95ffb70fdcbc6be063f81435b8ef2ec"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lerna --version")

    output = shell_output("#{bin}/lerna init --independent 2>&1")
    assert_match "lerna success Initialized Lerna files", output
  end
end