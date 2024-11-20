class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https:firebase.google.comdocscli"
  url "https:registry.npmjs.orgfirebase-tools-firebase-tools-13.26.0.tgz"
  sha256 "e4f3e73e4c1e1d21a10947aad04d65e4e997dabdccca78d5e96d0a19f64c4ca4"
  license "MIT"
  head "https:github.comfirebasefirebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_sequoia: "259c1e2bafd7ac0b20bebe137a17b96976de7d0d5a8628544f51cffa1a65f7fb"
    sha256                               arm64_sonoma:  "46f9bc4bbb36ded9204d72cb02fbc1aecf1875f932c2a9ef30e81acae65fb970"
    sha256                               arm64_ventura: "e9cd5d1d11ba4077bf6cc1b5a534a8062a4a3125ad3e48a5e2d856dbb019bf33"
    sha256                               sonoma:        "29ddef617a99b600c65477b4454a66780933416c25eeec6f5953e005798a527c"
    sha256                               ventura:       "05bfc066be6cc485b795269da75fb40bcb8ce227bf75c4de45fe84017d49decd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5cd50b98d53ab61237db55e2e033ee889407ec93d7dac1467aa77f21e2a8a78"
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