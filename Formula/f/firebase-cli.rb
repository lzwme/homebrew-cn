require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-13.0.1.tgz"
  sha256 "d620dd961f0ec641e869d846a17eb21d1580125062f5089a3d172034d9336959"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ba3e96aedcdf07aa05b21aeef4842554d8af48d842a00659a456efedbc8175a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba3e96aedcdf07aa05b21aeef4842554d8af48d842a00659a456efedbc8175a8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba3e96aedcdf07aa05b21aeef4842554d8af48d842a00659a456efedbc8175a8"
    sha256 cellar: :any_skip_relocation, sonoma:         "76bd9dc54097610e45e58a3853a89618c14bdc157103584377bd6f5cb3b11475"
    sha256 cellar: :any_skip_relocation, ventura:        "76bd9dc54097610e45e58a3853a89618c14bdc157103584377bd6f5cb3b11475"
    sha256 cellar: :any_skip_relocation, monterey:       "76bd9dc54097610e45e58a3853a89618c14bdc157103584377bd6f5cb3b11475"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20713d3a981aba2dbf77ef7aa6f3037c6d8842d59590fb1b9173d61208269871"
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