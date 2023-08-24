require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-12.5.1.tgz"
  sha256 "43bb7e87e7a3e2e17f3294504f6c2b4d6d71c92e07825bb46d332e22da6cd67d"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8cd58db65222a3c210aaf4d45326b6aa3f92c177ea1bf1fe0b93b5d8565ff7e9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8cd58db65222a3c210aaf4d45326b6aa3f92c177ea1bf1fe0b93b5d8565ff7e9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8cd58db65222a3c210aaf4d45326b6aa3f92c177ea1bf1fe0b93b5d8565ff7e9"
    sha256 cellar: :any_skip_relocation, ventura:        "1fba829918e5e9ff39e2ecfc36880bcce97bdbb0dda5b9f906aed83f4b721a1b"
    sha256 cellar: :any_skip_relocation, monterey:       "1fba829918e5e9ff39e2ecfc36880bcce97bdbb0dda5b9f906aed83f4b721a1b"
    sha256 cellar: :any_skip_relocation, big_sur:        "1fba829918e5e9ff39e2ecfc36880bcce97bdbb0dda5b9f906aed83f4b721a1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48b01d41a06c967a5ba70410af624e2d74f06eedf4f3289bafd1a7f21c942303"
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