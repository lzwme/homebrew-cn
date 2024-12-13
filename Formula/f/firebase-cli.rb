class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https:firebase.google.comdocscli"
  url "https:registry.npmjs.orgfirebase-tools-firebase-tools-13.29.0.tgz"
  sha256 "2acd1197b5e854802b06ba8ed643a031ec9cebb772953cc1fde7a90d8efee8e9"
  license "MIT"
  head "https:github.comfirebasefirebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_sequoia: "4b7d663c6078e817d6c0b38b6adfe72d0dab86a68ab116950cc16d28cb577d96"
    sha256                               arm64_sonoma:  "257629745961c7d2dedf1fb513633d232c91bed1fb58a20a805adc96f3bf695b"
    sha256                               arm64_ventura: "1d6948e3e159b6267271a0290d1d4559bf02c1244d4441404cfe8c4f31ee0a88"
    sha256                               sonoma:        "9b7d30b3fe343ecbe41c44f213e134ee29eac38f127393b0af3cb01399a6345c"
    sha256                               ventura:       "389199c3aaf00e34419b40211c20bad5f8f4715e2f25fb2ad332c18d2c62e2da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d5a6c03de3b8848ea8297a6d62a1a54116eeaae3903811ca979bf52fb2a923d"
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