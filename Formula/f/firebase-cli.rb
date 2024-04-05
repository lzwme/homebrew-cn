require "languagenode"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https:firebase.google.comdocscli"
  url "https:registry.npmjs.orgfirebase-tools-firebase-tools-13.7.0.tgz"
  sha256 "e9c269393fa757ea5316d6345d80a341167e3d17b9010db9907c5684f266c9f5"
  license "MIT"
  head "https:github.comfirebasefirebase-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "535e1a425d7c297a60ad2c6d8ba037bda254aac337dee6e54c18d6888ac7a174"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "535e1a425d7c297a60ad2c6d8ba037bda254aac337dee6e54c18d6888ac7a174"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "535e1a425d7c297a60ad2c6d8ba037bda254aac337dee6e54c18d6888ac7a174"
    sha256 cellar: :any_skip_relocation, sonoma:         "d97e847ba0e42fb8aa619ae3eef0935e4e7dbf14de4b4b1280f4c2d43842c3a8"
    sha256 cellar: :any_skip_relocation, ventura:        "d97e847ba0e42fb8aa619ae3eef0935e4e7dbf14de4b4b1280f4c2d43842c3a8"
    sha256 cellar: :any_skip_relocation, monterey:       "d97e847ba0e42fb8aa619ae3eef0935e4e7dbf14de4b4b1280f4c2d43842c3a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4c0e6ef6f461917145a091338281cd23b8b9e8ac50740a0b3328f4fb4e84843"
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