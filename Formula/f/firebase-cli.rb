class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https:firebase.google.comdocscli"
  url "https:registry.npmjs.orgfirebase-tools-firebase-tools-13.31.2.tgz"
  sha256 "5e61aa29df1606a3f81e55e8ac380293c179a4dc44bf09bb9f679cdb95aa9b5e"
  license "MIT"
  head "https:github.comfirebasefirebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_sequoia: "a579c006f8e9b6afda8daa967e3bbcae2cc4b8cf1a58185e95ba92b238403ef6"
    sha256                               arm64_sonoma:  "90f7bf03073b2e67964c3646dae17e553222d0373ef69729c466edc7d814365b"
    sha256                               arm64_ventura: "d053b30c853b9d2796a2e6cda4eb8e7121c9ade47d5384b6f3fb242cd98ecb47"
    sha256                               sonoma:        "038041b2492d2d5243c3efddf7736c144c2244a34ba655cda3e9b8b2e806cbba"
    sha256                               ventura:       "8214bfab5da32d543edeb95a68c6ba28026a0571cf005f3e887abf5c92c87aa8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d631b0b743e3a74c2aa05f904999edb22c5f40b4f28a6b86f90f337cd2decbf"
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