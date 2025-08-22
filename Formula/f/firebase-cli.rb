class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-14.13.0.tgz"
  sha256 "d2bf03f06874bab6251c00e098ee567e48ab8857a6c8bbaabf60699558ee8268"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "550c223adf6de6df6607081351bf31a619d9174e3da2baebf5e3107037d7da26"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "550c223adf6de6df6607081351bf31a619d9174e3da2baebf5e3107037d7da26"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "550c223adf6de6df6607081351bf31a619d9174e3da2baebf5e3107037d7da26"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe61c09300d9d4d1549b0643f50bf82710e18af7e829ef6f62c14821edb6386a"
    sha256 cellar: :any_skip_relocation, ventura:       "fe61c09300d9d4d1549b0643f50bf82710e18af7e829ef6f62c14821edb6386a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "35b6bfcc5dfbc258e285678c9b647c5b29503da59c386ceaf0cae6cd3bd5eac9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a848ad7f8594ba7a67c200fa25bf9d3044f666490bece8b8c4b51f3ba78c0dce"
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