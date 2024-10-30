class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https:firebase.google.comdocscli"
  url "https:registry.npmjs.orgfirebase-tools-firebase-tools-13.23.0.tgz"
  sha256 "9aca257a16e3a548b049c550da3ecaa64cde2de2c56cfe7316a8079376bf8e1c"
  license "MIT"
  head "https:github.comfirebasefirebase-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6894d286e0ac46a66181d15e6c11609680027fb220d5b4d2ab444f0538cfce55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6894d286e0ac46a66181d15e6c11609680027fb220d5b4d2ab444f0538cfce55"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6894d286e0ac46a66181d15e6c11609680027fb220d5b4d2ab444f0538cfce55"
    sha256 cellar: :any_skip_relocation, sonoma:        "b48f12c1e74f149a59d1707976b3bb1af0269f85cc482eec79a334828b4798f5"
    sha256 cellar: :any_skip_relocation, ventura:       "b48f12c1e74f149a59d1707976b3bb1af0269f85cc482eec79a334828b4798f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fce39dd9a72d6105f8d0244cd44bc1de223bcf9d8d7273d86726e5f4035bb8b"
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