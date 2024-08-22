class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https:firebase.google.comdocscli"
  url "https:registry.npmjs.orgfirebase-tools-firebase-tools-13.15.4.tgz"
  sha256 "1fe100e409d7674557470ac570bd9e3b7b94fba50825f291817c089b312b122d"
  license "MIT"
  head "https:github.comfirebasefirebase-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e909060173a1a40c8e0c4149b4e5e499702b4743af903e1ddb52cd17d424df7a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e909060173a1a40c8e0c4149b4e5e499702b4743af903e1ddb52cd17d424df7a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e909060173a1a40c8e0c4149b4e5e499702b4743af903e1ddb52cd17d424df7a"
    sha256 cellar: :any_skip_relocation, sonoma:         "be3c95706df04f3b37c162e1fd40cd3a2d9fa3b1b9e47ba5649a192a4e64737d"
    sha256 cellar: :any_skip_relocation, ventura:        "be3c95706df04f3b37c162e1fd40cd3a2d9fa3b1b9e47ba5649a192a4e64737d"
    sha256 cellar: :any_skip_relocation, monterey:       "be3c95706df04f3b37c162e1fd40cd3a2d9fa3b1b9e47ba5649a192a4e64737d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd56ae45c95a3fcade9eb6077c3ade0d66360df53f47954249a7574c6aa34b1b"
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