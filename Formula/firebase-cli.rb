require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-12.4.6.tgz"
  sha256 "b0dad6c710137eb9d26055c7ba93b7ce8fc3151d931a6c23919a1962b777066d"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_ventura:  "18d74eb888be8552412b5b6179482679ced39898542c311764c58134bcc97199"
    sha256                               arm64_monterey: "d28f4c37d7423dd053361cc256ae9509d0905cd3e37070bfbfb24f92ebb5f545"
    sha256                               arm64_big_sur:  "df7c59574594ddf27137153172c2e46e8582f9e6978ed2f33aa3543857850e52"
    sha256 cellar: :any_skip_relocation, ventura:        "84ab391a34eda43167b0bfd97057f58712b9d05dc8ef894ec7708bf53cebb1c5"
    sha256 cellar: :any_skip_relocation, monterey:       "84ab391a34eda43167b0bfd97057f58712b9d05dc8ef894ec7708bf53cebb1c5"
    sha256 cellar: :any_skip_relocation, big_sur:        "84ab391a34eda43167b0bfd97057f58712b9d05dc8ef894ec7708bf53cebb1c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7e4767982b864a3ddd84699b35b2781534294b1a4b3ebe38c12391f44fa683c"
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