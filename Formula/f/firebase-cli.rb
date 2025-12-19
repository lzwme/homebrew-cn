class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-15.1.0.tgz"
  sha256 "11f67ef56b98b807658ac88b200594b502e083c56e9645e023244413dabf2880"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a6848070e3cff155d4111abdacb470a2257b620a2611ca20535aafb73b3e8802"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da26afa26693d01bcd3b7a2c96ff30f2ac8e5525e8aee696fdbfabbb6e3c6cda"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da26afa26693d01bcd3b7a2c96ff30f2ac8e5525e8aee696fdbfabbb6e3c6cda"
    sha256 cellar: :any_skip_relocation, sonoma:        "3212de3a6b55502c769701587fa601932689a14320905b0a2a8be000995fce17"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11204f3964febade6829ed5a007d265a299d3fdccf0633315c9aa1b396395c57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11204f3964febade6829ed5a007d265a299d3fdccf0633315c9aa1b396395c57"
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