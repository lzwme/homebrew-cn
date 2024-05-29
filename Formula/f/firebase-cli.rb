require "languagenode"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https:firebase.google.comdocscli"
  url "https:registry.npmjs.orgfirebase-tools-firebase-tools-13.10.2.tgz"
  sha256 "cb340b746834a83f648c060f29daf91745466624060adf523bc937b428661315"
  license "MIT"
  head "https:github.comfirebasefirebase-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ed934cd59a31fbc9b8fb168ce253e8ddd459ebba9420487c5e7e410f4a3090c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ed934cd59a31fbc9b8fb168ce253e8ddd459ebba9420487c5e7e410f4a3090c9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed934cd59a31fbc9b8fb168ce253e8ddd459ebba9420487c5e7e410f4a3090c9"
    sha256 cellar: :any_skip_relocation, sonoma:         "3932a96a3e4a4488c490af4c3d7daf910c11944320ea5521665fdaefcfb6d996"
    sha256 cellar: :any_skip_relocation, ventura:        "3932a96a3e4a4488c490af4c3d7daf910c11944320ea5521665fdaefcfb6d996"
    sha256 cellar: :any_skip_relocation, monterey:       "3932a96a3e4a4488c490af4c3d7daf910c11944320ea5521665fdaefcfb6d996"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f0ef0bf7bc1543ff66271d87b9c60d09f6d8deafd6fbde7179c1750aa42f63b"
  end

  depends_on "node"

  uses_from_macos "expect" => :test

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    (testpath"test.exp").write <<~EOS
      spawn #{bin}firebase login:ci --no-localhost
      expect "Paste"
    EOS
    assert_match "authorization code", shell_output("expect -f test.exp")
  end
end