class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https:firebase.google.comdocscli"
  url "https:registry.npmjs.orgfirebase-tools-firebase-tools-13.24.0.tgz"
  sha256 "0ca2569efb39decd4985b8c160c4ca980b47fd38824c7da6ad2df1e144390e14"
  license "MIT"
  head "https:github.comfirebasefirebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_sequoia: "42b11ae4408f4627c7c15e25f8e9c7738d00da616e91a9dc675cece580448740"
    sha256                               arm64_sonoma:  "f18d59fea4d5312882f234e28a3f01e15b518a890e5d1b5127c0ff3d127a718a"
    sha256                               arm64_ventura: "2b824cc377fa15bcebe138366e6f5782cb3b1103743ce314f06a3144e5ec316c"
    sha256                               sonoma:        "9c63b815d35af05b6abe3f91863362be821fd67aaf3f2a88454011036b602a55"
    sha256                               ventura:       "bd4e0a5bf121e5bb724eb8148bae4752b6d16553f6d8f45c06b4622b2bd21447"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "960204a4fc58d1d06a7add6f50dbd19b1fda0ecf448a594c6e514dc1d9a26206"
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