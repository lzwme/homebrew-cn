require "languagenode"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https:firebase.google.comdocscli"
  url "https:registry.npmjs.orgfirebase-tools-firebase-tools-13.7.1.tgz"
  sha256 "868cd3bfb8a05184470753c61a100ee58491dd509ac98eec4e70127517df1720"
  license "MIT"
  head "https:github.comfirebasefirebase-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "76b8684e26b09dc80abed71f087dd46845af57fc8863b13c942a36a0dcc953c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "76b8684e26b09dc80abed71f087dd46845af57fc8863b13c942a36a0dcc953c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76b8684e26b09dc80abed71f087dd46845af57fc8863b13c942a36a0dcc953c6"
    sha256 cellar: :any_skip_relocation, sonoma:         "77749d82c553fe264be114d7773e3a781426dc3a319aea1b910f3001da62e6d1"
    sha256 cellar: :any_skip_relocation, ventura:        "77749d82c553fe264be114d7773e3a781426dc3a319aea1b910f3001da62e6d1"
    sha256 cellar: :any_skip_relocation, monterey:       "77749d82c553fe264be114d7773e3a781426dc3a319aea1b910f3001da62e6d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e58a934fe1d3718bd5d0cd919864a5a32e9d433310c72fe186cb9ba150b6ac5"
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