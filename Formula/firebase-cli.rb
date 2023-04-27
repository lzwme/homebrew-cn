require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-11.29.1.tgz"
  sha256 "cf7530bc994a6a44a8cac78c6ec3f8ee55032492c3d6edd01385e0139b1a08cd"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_ventura:  "c2df34e8622bb178f94add4e2582537415f912d5f5263fb8df8b8374397384b2"
    sha256                               arm64_monterey: "326e0e0f66c0534b39929178883dfdf845b862ff09afa77b8f49caf3863f3f7a"
    sha256                               arm64_big_sur:  "12e9ae5e0fa2faccd7bf98d0122845aa3b42a13923b37b26164ca99c0a5a727d"
    sha256                               ventura:        "ff5ab0ee97d439f2df413e1bcd996417e156b9dd5533286ea1b7e09e3c5b78b8"
    sha256                               monterey:       "ac7f36129f7a33ce9612f67fe38e236705b4cd82e1040d98f65785b5fba94774"
    sha256                               big_sur:        "2e91b99c26f26e4f0d2fdf7503c8a668650bda5cc4ca0a15867aebb1b9086d9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4cd7ccabaea472febb01a69460eb9f65dd93d61808cae4400a8d1c7eaaf23629"
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