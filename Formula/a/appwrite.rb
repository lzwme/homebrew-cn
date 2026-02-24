class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://registry.npmjs.org/appwrite-cli/-/appwrite-cli-13.6.0.tgz"
  sha256 "cbbc257f223fb705bd25d6d0aba0957e29341c730c6aaf63889a2daa50ab45c9"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a5fc89bdfb503517c0d845a96d14d878d558b1ce5e3b693153d84d8232ed6dd9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "450a3e7b9e098632851463d3b43cf4d9627e066c3838aa56da311840fbc7e235"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "450a3e7b9e098632851463d3b43cf4d9627e066c3838aa56da311840fbc7e235"
    sha256 cellar: :any_skip_relocation, sonoma:        "2863a6d7bb34f8bc5fdae6751578c16ba29c017402798264d2e831fdd80d4954"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b7eb3c417f27ff645372ba1e72495e8cd63a31dfe28fcc7c36dc5f53ee7a66c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b7eb3c417f27ff645372ba1e72495e8cd63a31dfe28fcc7c36dc5f53ee7a66c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/appwrite-cli/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    output = shell_output("#{bin}/appwrite client --endpoint http://localhost/v1 2>&1", 1)
    assert_match "Error: Invalid endpoint", output

    assert_match version.to_s, shell_output("#{bin}/appwrite --version")
  end
end