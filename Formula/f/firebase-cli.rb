class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https:firebase.google.comdocscli"
  url "https:registry.npmjs.orgfirebase-tools-firebase-tools-13.35.1.tgz"
  sha256 "f7e588178095ec237ec9255fd330540524ebe4be4b6f69b53e128cde4682550e"
  license "MIT"
  head "https:github.comfirebasefirebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_sequoia: "f2d1c5bcbf2a5d6cdb69ada21b6c14accdabe164fa00e9e45586ed8074bf397d"
    sha256                               arm64_sonoma:  "b362f15a319a122249146c88655d53736261a562ab3e8807a012374996bd24c2"
    sha256                               arm64_ventura: "232a3ce90f0a5a013f902885c824c475369a60a4e482cb95ac2b662c5a2acbc8"
    sha256                               sonoma:        "4a5a11742a1ed73e43e7dac7e0267903e0f2d2818f389040553538aefad89147"
    sha256                               ventura:       "2ff38bd51e06e82d22f9585f85300189861b969689a09a0119e8166a08093d7d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b8118a817aa7a5b508d51339d8756c597a5964baae67c07196d2b481edd0170"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bee6697cac3694f980d3898a401f562ac3f9d7d47f71b0522d1d5e722c721151"
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