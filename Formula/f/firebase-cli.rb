class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-15.4.0.tgz"
  sha256 "6cde53df3198f1dc09964572fb60b9ea148650ee4a4168413d771122fe982cd5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "37d1cf4d1961d0ea9b1936605c318e802f14c317073d644a699352b2b162c19c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41e840fb56f95f240047f26c412a7dd36962164e9d4ad606910fa9162f04d316"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41e840fb56f95f240047f26c412a7dd36962164e9d4ad606910fa9162f04d316"
    sha256 cellar: :any_skip_relocation, sonoma:        "0bf126192a115f1d5d9ad8c072743356611494dab5f2f8889c774930e77ef39d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "389975284a48490acc59684f80f98b30656a5ebdbb4c4fee5cf70fb6cb23be23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "389975284a48490acc59684f80f98b30656a5ebdbb4c4fee5cf70fb6cb23be23"
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