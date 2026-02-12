class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://registry.npmjs.org/appwrite-cli/-/appwrite-cli-13.3.2.tgz"
  sha256 "404325567c42e86ebbe585f403a0c82562e1bee6f86084edee8653a2c3057b2b"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ad08ea52f6d67753b13aa7ba82a0893fcb6af3607a6fafc1769815fff1bc3c19"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac92fa50a3ab75c33ed5aa1767c706327646dd1239b5eae9497fc6fc4c154293"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac92fa50a3ab75c33ed5aa1767c706327646dd1239b5eae9497fc6fc4c154293"
    sha256 cellar: :any_skip_relocation, sonoma:        "1cd887f4c5b3adbfb2727984454417d64d9e71953c3c49c16492b20cde800f74"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ab84d6c76c3a8d82129b64693ca258bf5623f4232efd1674f98f954639eff27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ab84d6c76c3a8d82129b64693ca258bf5623f4232efd1674f98f954639eff27"
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