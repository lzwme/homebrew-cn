require "languagenode"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https:firebase.google.comdocscli"
  url "https:registry.npmjs.orgfirebase-tools-firebase-tools-13.11.0.tgz"
  sha256 "195f44b0a8687f7aa7d95de87b5ac4a4133044ee96d0b526538de15694220c45"
  license "MIT"
  head "https:github.comfirebasefirebase-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6631bd9fb0b928541a7c9979ccd2898807f818301deab49a317335bec70f6e55"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6631bd9fb0b928541a7c9979ccd2898807f818301deab49a317335bec70f6e55"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6631bd9fb0b928541a7c9979ccd2898807f818301deab49a317335bec70f6e55"
    sha256 cellar: :any_skip_relocation, sonoma:         "174d48564b30a75ef38fbc0296bbbe0bddf33f90990627c18fe284ff54f448fe"
    sha256 cellar: :any_skip_relocation, ventura:        "423cc9e8486bd3204292f5ef3c2ed82c89913b4ae4bd0dabab8c052ad41a56b3"
    sha256 cellar: :any_skip_relocation, monterey:       "012ced3430abf4543fa3120b0e54a3bda7c4bec2d54a40496171a6d8b28652c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3a997fa14ece4222166c664616c1869c6130a74a21e1859ab1e246d1e395bbe"
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