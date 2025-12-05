class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-14.27.0.tgz"
  sha256 "09f6af948285fd3f72df7cf5191f10352f63143334df38c66118875527cc2aa5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "70dde0110f68c2dfb2bb9d7299fb9b19160f22c83470907f01d1a912d1ccc3fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "495cd4dc52fe57edf53bdcbb13aa31f8a14322779fed6053f1f8a1de3585686e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "495cd4dc52fe57edf53bdcbb13aa31f8a14322779fed6053f1f8a1de3585686e"
    sha256 cellar: :any_skip_relocation, sonoma:        "747441dde97bf323a845f68d0497c674a27ad9124f165b6cfe5f20811a4c7707"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "793f37a902fb191e1de0e04bddd3efb2782aa7d3df49353fd9489b28734aae1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "793f37a902fb191e1de0e04bddd3efb2782aa7d3df49353fd9489b28734aae1a"
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