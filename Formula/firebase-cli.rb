require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-12.1.0.tgz"
  sha256 "67e2ff2fbc6cfaf54ed324815f9de289def1193bbe61fcb6f7c89c647b39e77b"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_ventura:  "1bab89e74df71cb8890a2ab0cda0c715eb551b40166c20083c14bdf2c25e03d8"
    sha256                               arm64_monterey: "5b69a056b8e11f279e43ca53fe5fef9b9cd821cb25fe5a674cbcad8d6f127d1c"
    sha256                               arm64_big_sur:  "6cbc6288adc67787c6f112ae11efe2c16630a2bf8cec318dbf6ea85fa1500801"
    sha256                               ventura:        "2532db34de5a1d54080cb412b04827e46e7f995d6f2e13d92ea92f98ffea9eb7"
    sha256                               monterey:       "8fefd4475a88875b896e7d3d79b28dd9e0c02a205b9224e2393d6e35b0ccbd5c"
    sha256                               big_sur:        "17df4820f30c19114d6491475d10d2e46e34b7a661ffc0830030b6ea175900ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45abaab2b0d9853a1989063b13d2782d9935474b4e2d162fb5d2cb182cf12927"
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