class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https:firebase.google.comdocscli"
  url "https:registry.npmjs.orgfirebase-tools-firebase-tools-13.27.0.tgz"
  sha256 "2519d620aba01f74ad9cfe1f71a01f6d0ae37c96fd0ef640ee30f6764e7d2981"
  license "MIT"
  head "https:github.comfirebasefirebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_sequoia: "02193db50f6fa1dbbe590496770cd95d67790c18ec775c1304dba3f09aeeedc4"
    sha256                               arm64_sonoma:  "512706ee71f9310efddcdd029b658bc957df26e7d48f7be6efd9254d616f7b31"
    sha256                               arm64_ventura: "56fdc43dcbddb368d0cb95c0a96232ea50333d69ca44330e7906966527bce7cf"
    sha256                               sonoma:        "670fc3095d352991abd005097a6ab97aa41689ade324acad611aec18acd33a0d"
    sha256                               ventura:       "b1fc85b919e2c48cea6c8404336d28768089dfbe5d96ddffa2067756bbf7e1dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a73c27d7c9d233a26c600c5036ed470ca1e5f43f695c65a7fe5a38e6e0638fd9"
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