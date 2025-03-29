class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https:firebase.google.comdocscli"
  url "https:registry.npmjs.orgfirebase-tools-firebase-tools-14.0.1.tgz"
  sha256 "04356b2cbbd37f84da991001ab8a9100292ffb829a0d571fd5f15aa19b4cffdb"
  license "MIT"
  head "https:github.comfirebasefirebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_sequoia: "b913cb9664b68979622fa49b9bfc40008a7f79161b2993902dd9624338102f66"
    sha256                               arm64_sonoma:  "bddb4f9aa7088c53269f0e94827e81399be6ab0d155ec3cabe5f1438c0092f6a"
    sha256                               arm64_ventura: "dd444dab5d43675776cdf91ed4b8e7d038733ab94228532030b1594f1910fbc5"
    sha256                               sonoma:        "be68cbf40545fc7a4807a6f18304a381fdb1337268722832557f22c389e917b2"
    sha256                               ventura:       "840a0dd43d68d4743fc44449c7bdc880e33a92534235c8c5c22c81ea1e4a0537"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dea5254f1c78d0461d1073de7411f620560f5a13f9aaa6564534a10152e18b29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df2d2e98fc3959e08e7ba2e391cd334d57a6e6400a2d5cace8423f4403f31a89"
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

    output = pipe_output("#{bin}firebase login:ci --interactive --no-localhost", "dummy-code")
    assert_match "Unable to authenticate", output
  end
end