require "languagenode"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https:firebase.google.comdocscli"
  url "https:registry.npmjs.orgfirebase-tools-firebase-tools-13.9.0.tgz"
  sha256 "ebbb7c7b53547e75e263bf0ae0d90b59da30c26523729bee593d1d857973f026"
  license "MIT"
  head "https:github.comfirebasefirebase-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "928f2aa0e1350d3dc4ef13c2a86f7f3727f4e360a3d87311bd90f3f4101c8a3d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ded5e7fb0d3437af32bfecc054f02cd79e8676c05799d37f9f04bf0b2f3a084f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6618a746edb0188e38e5fa984afd60c16c87188395708fc3b86bb52b5d1db46c"
    sha256                               sonoma:         "74c5bb55ec58cb7ccc8cafd816e01e5380b5edb979aa2a1a87155b13131b4a77"
    sha256                               ventura:        "8de5800256764ae02ded68b13950a48c87df1da3ddba46c9e1722b02cb6c4a64"
    sha256                               monterey:       "d10eda88faf8a2f18a167b6fefbbcf68c6dec739512a2832e4693dbd56de5a43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6fb3412b98389db7f229b351da0ff04caaaa796c78e2071e2bfb6c0afe16a1b7"
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