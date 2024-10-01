class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https:firebase.google.comdocscli"
  url "https:registry.npmjs.orgfirebase-tools-firebase-tools-13.20.2.tgz"
  sha256 "22d7cba6438f8acffb9cfe0e7956873fbfb6991354c54a2d7b9a5178fd863044"
  license "MIT"
  head "https:github.comfirebasefirebase-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0fef2dc3881ff01f4a5f13a8f03cf477a6ac2d46524db4a39f3185bd743d03e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0fef2dc3881ff01f4a5f13a8f03cf477a6ac2d46524db4a39f3185bd743d03e9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0fef2dc3881ff01f4a5f13a8f03cf477a6ac2d46524db4a39f3185bd743d03e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb10988b320b2da69de83a069c26d1bdde2f80a5a08d780ee885dfe476d0d45d"
    sha256 cellar: :any_skip_relocation, ventura:       "bb10988b320b2da69de83a069c26d1bdde2f80a5a08d780ee885dfe476d0d45d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a76bfb253137b227eb5c03b90df58f5dac74cb44b5f5fa1d8c3b0a441b9d72a0"
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