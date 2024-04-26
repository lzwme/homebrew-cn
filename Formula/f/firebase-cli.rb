require "languagenode"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https:firebase.google.comdocscli"
  url "https:registry.npmjs.orgfirebase-tools-firebase-tools-13.7.5.tgz"
  sha256 "f08842f3eabec4b587ffc0bd4c4873c33fff409033a44bcbf741becc9a29754c"
  license "MIT"
  head "https:github.comfirebasefirebase-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e22abadd3d59d40169c869eb69c6a9d1206c3a8bcaef41c499a2575bf9236d24"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e22abadd3d59d40169c869eb69c6a9d1206c3a8bcaef41c499a2575bf9236d24"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e22abadd3d59d40169c869eb69c6a9d1206c3a8bcaef41c499a2575bf9236d24"
    sha256 cellar: :any_skip_relocation, sonoma:         "fbf2a979f20b90fce815ca07208937f235a80af1b5c777cb110eb4d5d4cb7214"
    sha256 cellar: :any_skip_relocation, ventura:        "fbf2a979f20b90fce815ca07208937f235a80af1b5c777cb110eb4d5d4cb7214"
    sha256 cellar: :any_skip_relocation, monterey:       "fbf2a979f20b90fce815ca07208937f235a80af1b5c777cb110eb4d5d4cb7214"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8bccdd24a939ab8b3135a544c88f5270c3124741b86de71fbb671ace74cfdc1"
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