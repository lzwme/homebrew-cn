require "languagenode"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https:firebase.google.comdocscli"
  url "https:registry.npmjs.orgfirebase-tools-firebase-tools-13.5.2.tgz"
  sha256 "c1bdac1f5d7ae50f355cd97d57b66466bfcaf4c8f6a73be6545e724e9a2e72d6"
  license "MIT"
  head "https:github.comfirebasefirebase-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d844f68c417859151a9f43a348b8c055eb9adc5579be62fb4ee29722fd1b108d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d844f68c417859151a9f43a348b8c055eb9adc5579be62fb4ee29722fd1b108d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d844f68c417859151a9f43a348b8c055eb9adc5579be62fb4ee29722fd1b108d"
    sha256 cellar: :any_skip_relocation, sonoma:         "9e7143c3c04b6d58b516df43766eeeb9c11965a6516346f5ead42f697da1a1e4"
    sha256 cellar: :any_skip_relocation, ventura:        "9e7143c3c04b6d58b516df43766eeeb9c11965a6516346f5ead42f697da1a1e4"
    sha256 cellar: :any_skip_relocation, monterey:       "9e7143c3c04b6d58b516df43766eeeb9c11965a6516346f5ead42f697da1a1e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd52cc02b1ca1b670e6d0b0fd8e4804278e135c1995ebf1e112dc7dd3a3c2544"
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