class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https:firebase.google.comdocscli"
  url "https:registry.npmjs.orgfirebase-tools-firebase-tools-13.29.3.tgz"
  sha256 "c5b45ebdb146320047f7727c6bba38b28e73488e3da84d98a4267f45a482f20c"
  license "MIT"
  head "https:github.comfirebasefirebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_sequoia: "0343f1d2bfa8cc1f1ba442aed655b0baf68bbd4adcff4f79e1368051b2159a1e"
    sha256                               arm64_sonoma:  "bf465a265901cf40c94126b192ab9c4825e53e8d70bfdd296a68182f7ba580e8"
    sha256                               arm64_ventura: "507799c4a978e8e2097ac39c4bce7fccd6c6de13f31276f05fbc6d4c2284fe9d"
    sha256                               sonoma:        "f010357e2b1598013b78c8ac5fdb30f3043be1578aa8c222b89d9b6969019eba"
    sha256                               ventura:       "67867811be137c1748ee0aab85df484e0282536a1e03da432a5b35b57ec24996"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98014c496771624ac4a9b0e1384218e8d39fc94ea4553f8cdb7fc8992351b3b5"
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