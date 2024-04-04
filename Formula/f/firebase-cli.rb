require "languagenode"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https:firebase.google.comdocscli"
  url "https:registry.npmjs.orgfirebase-tools-firebase-tools-13.6.1.tgz"
  sha256 "9bd644d19177ac87eea73a907ded7a880e42ac1c9392e519194623258e839133"
  license "MIT"
  head "https:github.comfirebasefirebase-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a0250667dca4f83bb6899317da8982ff522c4087e9696bbc7b539a5a53ea8aae"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a0250667dca4f83bb6899317da8982ff522c4087e9696bbc7b539a5a53ea8aae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a0250667dca4f83bb6899317da8982ff522c4087e9696bbc7b539a5a53ea8aae"
    sha256 cellar: :any_skip_relocation, sonoma:         "7f8c8bd532db94e28f737a70ad05c104b72d67c32d85e1b970ad0ca332ad29d0"
    sha256 cellar: :any_skip_relocation, ventura:        "7f8c8bd532db94e28f737a70ad05c104b72d67c32d85e1b970ad0ca332ad29d0"
    sha256 cellar: :any_skip_relocation, monterey:       "7f8c8bd532db94e28f737a70ad05c104b72d67c32d85e1b970ad0ca332ad29d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16d8ab3d32da023ca80d59b8df2f64ee9f2e46db3a5220c1bc9ab52fecff7734"
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