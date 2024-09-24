class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https:firebase.google.comdocscli"
  url "https:registry.npmjs.orgfirebase-tools-firebase-tools-13.19.0.tgz"
  sha256 "302073b105b67348512caec3364a5ebde12d3e402a926f51e4d90fb9cacd1bc9"
  license "MIT"
  head "https:github.comfirebasefirebase-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e9c91533c4d4d78437e55625fb74f8d7ae35750175e0004710175a583fc9d98"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e9c91533c4d4d78437e55625fb74f8d7ae35750175e0004710175a583fc9d98"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1e9c91533c4d4d78437e55625fb74f8d7ae35750175e0004710175a583fc9d98"
    sha256 cellar: :any_skip_relocation, sonoma:        "8905785d63b959e30428338f37434557db85f8020291fbc5335639b284d14a45"
    sha256 cellar: :any_skip_relocation, ventura:       "8905785d63b959e30428338f37434557db85f8020291fbc5335639b284d14a45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f91b26308b1648668ec0f6c56bfe3595b47da20de6ab0a63b9b633ab0f6cea2a"
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