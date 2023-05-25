require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-12.2.1.tgz"
  sha256 "a56337dbfecc998dfb2b134313362c9a778877fc594dd3331d3f4f48385f4c77"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_ventura:  "224d2a1270d6fad0ccaee43f5d29ea83935a9c5bebdd382991b461a77ef1ff89"
    sha256                               arm64_monterey: "2859e376d7cc6971a63f0e18c0bf00c478a75cdea9842274d52c705df9433f62"
    sha256                               arm64_big_sur:  "e026a289666bed363827915bc49ba273437a5eae2c3eb01267188bf3f8b8b82a"
    sha256                               ventura:        "f4b2d3d058a75762a83d7ed2b02dfdf61542d3ea1aa0aedeafa907fff47afb82"
    sha256                               monterey:       "bf32e27a779b95102f2e1c3802530920d39e6fa897229fd362da3b5166428b68"
    sha256                               big_sur:        "2e0682ec9649a306d073cf9ab0044942c27a7a87c6d941c12bfab8724a4f2278"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35d92f924d640d91f12cf7b66f638f14c90c543e2f337a663dd5bbf04d77b836"
  end

  depends_on "node"

  uses_from_macos "expect" => :test

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.exp").write <<~EOS
      spawn #{bin}/firebase login:ci --no-localhost
      expect "Paste"
    EOS
    assert_match "authorization code", shell_output("expect -f test.exp")
  end
end