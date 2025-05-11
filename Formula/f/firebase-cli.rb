class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https:firebase.google.comdocscli"
  url "https:registry.npmjs.orgfirebase-tools-firebase-tools-14.3.1.tgz"
  sha256 "7b591c2e692f857639e01cfb43c47802a03346298eefb473c12bd0cafe20b0a5"
  license "MIT"
  head "https:github.comfirebasefirebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_sequoia: "4f287564636504825950c7c2600c8b5f63dd6a711b11c65ebe40ee8e09e867ad"
    sha256                               arm64_sonoma:  "3347432626b7a0fdc445c623bf42fc80162e4c188315c4fb105e8369fcd6e07f"
    sha256                               arm64_ventura: "6dfa8a64ddd2ed56f447429619066d5e937e8cc82c190d80b966055685683959"
    sha256                               sonoma:        "12471bd0c8abd69a31d95c40b936a687be46205ed08d036bab6fadf1c4d5e023"
    sha256                               ventura:       "e96c07aa83ca9ff349f1d2332ca985d3b9c19c384eb5a8791e0073865e2dd01c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31235dd38def495136cf67ffcfdac59e04d3e979e8207332798dd29cfdc0b779"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf6d0550f596984cbc90b0667a39ff54f25e81066c3aa2033e9ee12bf212930b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin*")
  end

  test do
    # Skip `firebase init` on self-hosted Linux as it has different behavior with nil exit status
    if !OS.linux? || ENV["GITHUB_ACTIONS_HOMEBREW_SELF_HOSTED"].blank?
      assert_match "Failed to authenticate", shell_output("#{bin}firebase init", 1)
    end

    output = shell_output("#{bin}firebase use dev 2>&1", 1)
    assert_match "Failed to authenticate, have you run \e[1mfirebase login\e[22m?", output
  end
end