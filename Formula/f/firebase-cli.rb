class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-15.5.1.tgz"
  sha256 "e19ff92a556522836d2f4fc80c4643fc2d57eecbb2d0ee8966a03636f3f9cbcb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4cbcaf18c4666c641be427a4a9bccfdbaf9c4f0d40d9c4ea0b049ed8e79adbba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ba931ab97db7a405d1cc3e7a87be83434fff332f175da2031790b045872fce0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ba931ab97db7a405d1cc3e7a87be83434fff332f175da2031790b045872fce0"
    sha256 cellar: :any_skip_relocation, sonoma:        "c66b09c69aa38e3c00b189b9eff57ae5442f9cae149f7e35bbdd0816bc5f7869"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f17dd64db3208ad5ee9dfc9849e87c45414f44f9c76a23512bc9dbe3732f6b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f17dd64db3208ad5ee9dfc9849e87c45414f44f9c76a23512bc9dbe3732f6b7"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/firebase-tools/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/firebase --version")

    assert_match "Failed to authenticate", shell_output("#{bin}/firebase projects:list", 1)
  end
end