class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://registry.npmjs.org/appwrite-cli/-/appwrite-cli-17.2.1.tgz"
  sha256 "9a3e3e9025bf6957bce55773fa4ccf2db9cfb36e27bb92325a511eaba1dc0e95"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "26724467d8cd94ccc02f08d5bba3b73d369fb369a72a8bb7c2a3a4e50ff41879"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf4a3b55ca61d2a332d7cbe3aa92b35210b7f1f11a1c8c4eaf387132b18212ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf4a3b55ca61d2a332d7cbe3aa92b35210b7f1f11a1c8c4eaf387132b18212ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff042e95eebfba875a6f571f0fd9e08f67e3cb950557ea2290ade24cecdc6183"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f29d1b78921a679df7f778ba2fb91547dde4606eab8eb132ca5adac705187f17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f29d1b78921a679df7f778ba2fb91547dde4606eab8eb132ca5adac705187f17"
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