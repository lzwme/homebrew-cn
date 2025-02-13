class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https:firebase.google.comdocscli"
  url "https:registry.npmjs.orgfirebase-tools-firebase-tools-13.31.0.tgz"
  sha256 "b25f49bf9dc0fcb7d047d8413047bbd64fe250ddabe33daf0eca3c0751d860a0"
  license "MIT"
  head "https:github.comfirebasefirebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_sequoia: "490a2fb077fd09128b71a3dec5aae8d5002ab9e2a41e2a7550d3b84a672e34d8"
    sha256                               arm64_sonoma:  "5302fe4575d5c3e3b410c557a45620f5b87e4725c6b7a1fa25454b703b22d920"
    sha256                               arm64_ventura: "0d9946b2c72138be7827665d3a8f27077b902bafb882fe227dda5675dfe82605"
    sha256                               sonoma:        "c6347dda234bf7988f59a3441850b3db3e2c3971897613ca92a0a59e5c54798d"
    sha256                               ventura:       "3a9c7babe97bd11e88c05b17311eaaa306d3edbb30bafc81274613e3b4fd9d81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1823f4e5fb82e22bb64e1dcee8696021a6f2d4fb2b70cc0b0d83eac1088654f5"
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