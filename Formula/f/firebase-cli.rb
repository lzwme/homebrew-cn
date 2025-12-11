class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-15.0.0.tgz"
  sha256 "8d124f96f0fec3c5e0604a5556648bd5378cce800e93b8824381fcb634236364"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f188af1e15774b403c2969b429dc19be1c369e254dce771b205c77a338d51eef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36bb9ced2355a99c89d47bf8fa413141fb6bfe64dcd8f9936ab3b814b43787fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36bb9ced2355a99c89d47bf8fa413141fb6bfe64dcd8f9936ab3b814b43787fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "7640c39d32ffa3b2179b55e966d08184f4328ff8f3e282529315470cb409dce3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b96c04c61b23a58dee7ad274849e04938b0f639bbfeb20c03ce763b712b615a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b96c04c61b23a58dee7ad274849e04938b0f639bbfeb20c03ce763b712b615a5"
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