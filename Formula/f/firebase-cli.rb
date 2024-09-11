class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https:firebase.google.comdocscli"
  url "https:registry.npmjs.orgfirebase-tools-firebase-tools-13.16.0.tgz"
  sha256 "adc57e6528621ed68e1e12256c7023d9f64da7b7d7d9b7cd30c29733f7237f1c"
  license "MIT"
  head "https:github.comfirebasefirebase-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b7a5679193c1a5c6251579a130595632ad16f612259b939a2706ecbc1bae2f5b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "04699a724400f740ba2e9b7f8490eb098d493d018f184577785094e589fb3e67"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "04699a724400f740ba2e9b7f8490eb098d493d018f184577785094e589fb3e67"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04699a724400f740ba2e9b7f8490eb098d493d018f184577785094e589fb3e67"
    sha256 cellar: :any_skip_relocation, sonoma:         "759f22913997b8d0518f4f9e33b862e48f24b60fb59efd71f4f651a147d06ed1"
    sha256 cellar: :any_skip_relocation, ventura:        "759f22913997b8d0518f4f9e33b862e48f24b60fb59efd71f4f651a147d06ed1"
    sha256 cellar: :any_skip_relocation, monterey:       "759f22913997b8d0518f4f9e33b862e48f24b60fb59efd71f4f651a147d06ed1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f7147514188b4e359244d72278b270253d13c34e0ce86d38b17e578a1fa4e7c"
  end

  depends_on "node"

  uses_from_macos "expect" => :test

  def install
    system "npm", "install", *std_npm_args
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