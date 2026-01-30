class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-15.5.0.tgz"
  sha256 "4df35e4855268906b33fbbfb2973a58a0fa379654735a6735a1a6b71c093bb19"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f3e69f4f356c54ff4ebc56f44861c95ea280aa69e2ec450276477ba448a9826a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7676f408d40777d1c7c4cd8ae5345ec675bb9b185d16ef24dba60f9942ca7c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7676f408d40777d1c7c4cd8ae5345ec675bb9b185d16ef24dba60f9942ca7c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "579ef959413c4d86425f6ee8c6cbfea25c41a52d63a50fbbcaca3d9a99edd679"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7fcd886d457e0fabf8a915ede97ef81fbed01688616164bbcfaf9c2da79f35cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7fcd886d457e0fabf8a915ede97ef81fbed01688616164bbcfaf9c2da79f35cf"
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