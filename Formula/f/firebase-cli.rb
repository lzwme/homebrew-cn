class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https:firebase.google.comdocscli"
  url "https:registry.npmjs.orgfirebase-tools-firebase-tools-13.23.1.tgz"
  sha256 "768d0b959b110f9fb929ea9f9c162c1448cd3b34648a664853092030f948545d"
  license "MIT"
  head "https:github.comfirebasefirebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_sequoia: "f55453491b9d2b482d70b1ecaf8fa9994882af5bcc6b40353ede22ebc62388d5"
    sha256                               arm64_sonoma:  "5b2f2dc6f0ccf36072c2ee26a511cc1a136750a18484ffc7b4cfc233e57d90a1"
    sha256                               arm64_ventura: "cb54b978a8157ab929f2a45802b5666c482210e9b45d30d6647af0dfc6e74a7b"
    sha256                               sonoma:        "bef845ae9d77b321bf2cd37f0aff15ec22f4a4dd3d6b5847fb50b4d91aeace73"
    sha256                               ventura:       "64d941102d799c5e3f59baf0b28d0dd32f637d9c4ac1902ffa0d7fb51e4f6535"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "802635c84c82e6d21b9c24313007db1968084ab4b643ae134c3204194742396d"
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