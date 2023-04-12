require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-11.26.0.tgz"
  sha256 "e1f6a29830bf3126f710df624d1595f87eeaa8662bd2877e01af918aa23982c0"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_ventura:  "ac9217570ce5fc35056ec02274c8ceae4abb6456490ed2908d8433c58abfc44a"
    sha256                               arm64_monterey: "a6de8ec3ac63f32f2d889b1e99c35135c2b42e898d858ed21933ebd22ffc7499"
    sha256                               arm64_big_sur:  "9cafc0ef46c30a64eb3ec5ba6c647fd97a1f68cabf7155b2dbfe3b08ed6cdf58"
    sha256 cellar: :any_skip_relocation, ventura:        "33a4697e64b45d28a4d1407a73dacef38c0dc6aabbf9fa097bdf3086055b84f7"
    sha256 cellar: :any_skip_relocation, monterey:       "33a4697e64b45d28a4d1407a73dacef38c0dc6aabbf9fa097bdf3086055b84f7"
    sha256 cellar: :any_skip_relocation, big_sur:        "33a4697e64b45d28a4d1407a73dacef38c0dc6aabbf9fa097bdf3086055b84f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a36620e8ae565249cafe52344d887ef12868ac8ea6eb98d91d2f063b11a3f31"
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