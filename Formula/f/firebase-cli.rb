class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https:firebase.google.comdocscli"
  url "https:registry.npmjs.orgfirebase-tools-firebase-tools-14.0.0.tgz"
  sha256 "c75595b16590b9026769d3e825e2bbbf66e2d03aa86bc2b695138157321fec4f"
  license "MIT"
  head "https:github.comfirebasefirebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_sequoia: "36a5222adb302d05cc2a995aabf6649bca3c4c84b77c1616e54a68b2394d8225"
    sha256                               arm64_sonoma:  "5261f5da10f466bd8ada78ce3a287b14af521155c69848c16d1affc92f6c5b36"
    sha256                               arm64_ventura: "0425f2d41d274a7215270cdf15e24caf863d3178f968bcf2d272372b7b161fa3"
    sha256                               sonoma:        "88e858788089a5bd45fe8521cbd91f23c5d8685d5d5893bd298910a3df3e94c9"
    sha256                               ventura:       "a4721c80053aa5406a1c8f0cf8cfd9c986efb28b46dd36a2feaa80592f9c8640"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1e0218db5c311960ff7ff98af915979cc1ff09483d4e8c893e7c4392792ef7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c02ab8690f698f789319446da4615e4cfce36b31eb273e1bdfb3048d1b0dc62"
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