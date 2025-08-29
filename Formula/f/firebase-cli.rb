class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-14.15.0.tgz"
  sha256 "7796f04d8f4f52e5ce8b4836b8d71c7ba677647776f09b6b4883ae1317c1ea56"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b199296b9d91f7f53ebb2f8a025ea4c60fee3151ba8fe08c807ff8281e89bd4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b199296b9d91f7f53ebb2f8a025ea4c60fee3151ba8fe08c807ff8281e89bd4b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b199296b9d91f7f53ebb2f8a025ea4c60fee3151ba8fe08c807ff8281e89bd4b"
    sha256 cellar: :any_skip_relocation, sonoma:        "b4c10728336e4cdb264c51f7e6dbb15d0ccbf557ecdb42188545cecc7822bfae"
    sha256 cellar: :any_skip_relocation, ventura:       "b4c10728336e4cdb264c51f7e6dbb15d0ccbf557ecdb42188545cecc7822bfae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79b5436e68ce48dbadc31497d14d673fa0c02fe58d863f1c0bfaf2f60c623ed6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7746f9e32fc8c463c0f0d7e2a62db24636880090f0ea6492953e61f42b734917"
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