class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://registry.npmjs.org/appwrite-cli/-/appwrite-cli-22.2.2.tgz"
  sha256 "3d12da64bf9dc138da4c972f36184c91aa28301649c2e1377a68e02ca3f67bcf"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "219d1568f4a7c16fd268c016696af5882e63f1e1d57bebfa7c9ae4c9e17b3c4e"
    sha256 cellar: :any,                 arm64_sequoia: "4e86273c5bc32958f93c8ea472d5b18302708b4527ed01d831872d35b2b5c3e5"
    sha256 cellar: :any,                 arm64_sonoma:  "4e86273c5bc32958f93c8ea472d5b18302708b4527ed01d831872d35b2b5c3e5"
    sha256 cellar: :any,                 sonoma:        "63f4712368f323ede0ee2274322720bf95910b256853b5ac512b8cb4fb99fb28"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f3aaf083366af4ce42e855cec6238d35766d8549b37440b9166102bcf3a7acd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ca70424860bbe64bb402fe2c303ff71ca4164feed65727b3417cb9176151ebd"
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