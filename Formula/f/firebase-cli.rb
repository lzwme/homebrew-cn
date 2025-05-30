class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-14.5.0.tgz"
  sha256 "21ea8b93d3f8c2d1a807f6497e1e4dcde5c080025d88cc53ad4d5041a887ba17"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d09caa94c35e1fe743bcd4ea38d7b0808aeff211092012556bb449ec52c0a52"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d09caa94c35e1fe743bcd4ea38d7b0808aeff211092012556bb449ec52c0a52"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6d09caa94c35e1fe743bcd4ea38d7b0808aeff211092012556bb449ec52c0a52"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2cb06325c09b6de68b8418e4b266396c13aaee67abc77646c9803fecef2af65"
    sha256 cellar: :any_skip_relocation, ventura:       "b2cb06325c09b6de68b8418e4b266396c13aaee67abc77646c9803fecef2af65"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f479c6a12f6d646c48a13a76316b0e9880abbd392f51db6e62ab01f2071319cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98ccb6f6846c67b6e187425fa9b3cb1ab28aa655dfc43d335da98967f8ee818e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    # Skip `firebase init` on self-hosted Linux as it has different behavior with nil exit status
    if !OS.linux? || ENV["GITHUB_ACTIONS_HOMEBREW_SELF_HOSTED"].blank?
      assert_match "Failed to authenticate", shell_output("#{bin}/firebase init", 1)
    end

    output = shell_output("#{bin}/firebase use dev 2>&1", 1)
    assert_match "Failed to authenticate, have you run \e[1mfirebase login\e[22m?", output
  end
end