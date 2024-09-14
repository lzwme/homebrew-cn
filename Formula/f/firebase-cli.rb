class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https:firebase.google.comdocscli"
  url "https:registry.npmjs.orgfirebase-tools-firebase-tools-13.17.0.tgz"
  sha256 "7c78518549d83b2fff976585e55955e82721152123c07e8d4e865ea411925335"
  license "MIT"
  head "https:github.comfirebasefirebase-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "aaeaa67ea48c51bcab561ca1fce719b01f64471ce819bc3a708b092e3f5f9ead"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "01913260c1507a3efc8874ebaad3f0ac892c51d94029cb3a1422d40c324bdb8f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "01913260c1507a3efc8874ebaad3f0ac892c51d94029cb3a1422d40c324bdb8f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01913260c1507a3efc8874ebaad3f0ac892c51d94029cb3a1422d40c324bdb8f"
    sha256 cellar: :any_skip_relocation, sonoma:         "161a705e1cebdd16da38caea05ecbc82631f6b26f4243fef559125667515b741"
    sha256 cellar: :any_skip_relocation, ventura:        "161a705e1cebdd16da38caea05ecbc82631f6b26f4243fef559125667515b741"
    sha256 cellar: :any_skip_relocation, monterey:       "a7dd0621e93d0f4e63f34b995f850408d4db7b6d4ce286c14017cfffd5015a5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8fd1b8687b04a6cf3b11284f5513cc8277a30d4179720e98dda1982023b0416d"
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