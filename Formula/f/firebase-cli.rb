class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-14.8.0.tgz"
  sha256 "da0b14115621ce46347ab2e966dd53d804e1a62ce33345ca016b8c6e4b9a6a71"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1a13adf375826de73939c22908ae32daca15f23597b10cacd9d2bfb549eef87"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1a13adf375826de73939c22908ae32daca15f23597b10cacd9d2bfb549eef87"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a1a13adf375826de73939c22908ae32daca15f23597b10cacd9d2bfb549eef87"
    sha256 cellar: :any_skip_relocation, sonoma:        "e54c31feb96928d90f3d48ff966ee597ae9dacb906d8d127c78321959ad12dd7"
    sha256 cellar: :any_skip_relocation, ventura:       "e54c31feb96928d90f3d48ff966ee597ae9dacb906d8d127c78321959ad12dd7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2ae012cdb0aa285f8cb9a88c230772ed31283ae1b4b42f36f0973b052508c8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1799687720a55912d7c619249dde9d562b30bb27ed40456c9018adef877d3b75"
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