class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https:firebase.google.comdocscli"
  url "https:registry.npmjs.orgfirebase-tools-firebase-tools-13.31.1.tgz"
  sha256 "a525c68a3cf3a8c5f369991a4897c09d79899690d0b1a9a3d1db2ca0463de27a"
  license "MIT"
  head "https:github.comfirebasefirebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_sequoia: "11e1f19524a38b794585db6f444ad1352b030a6872ce6d553870aabd988998ff"
    sha256                               arm64_sonoma:  "a7b66cb2aad3de30a69aa90a675c680b13e273ef2ba14d376aa1d9eadf930b75"
    sha256                               arm64_ventura: "07a94b399534e4caedaaefb52ac22ba0ac4856ecd96535721d0c34cfbb2ba3d2"
    sha256                               sonoma:        "74bbcc83f8e78395f2ff0e99c4d51bb0e5c67b31693efc9e6463b1af74c2dee4"
    sha256                               ventura:       "5b10ca3e7cb505e9cc635574dc96fad84a75ea03b64160882e5e985c2e35a4c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "531b65315006d820f94e617e846ad9bfd1525d6e1e65f5d5a8a59e215f87aa4b"
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