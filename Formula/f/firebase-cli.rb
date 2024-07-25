require "languagenode"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https:firebase.google.comdocscli"
  url "https:registry.npmjs.orgfirebase-tools-firebase-tools-13.14.0.tgz"
  sha256 "25ee4533a9db3e20b5b483102c34d00be790c77aa4500e90abea7478121dd577"
  license "MIT"
  head "https:github.comfirebasefirebase-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "03b42449982c60f78135e5efd75ee2d35aada3917d5206828f4f67ed47bae11d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "03b42449982c60f78135e5efd75ee2d35aada3917d5206828f4f67ed47bae11d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03b42449982c60f78135e5efd75ee2d35aada3917d5206828f4f67ed47bae11d"
    sha256 cellar: :any_skip_relocation, sonoma:         "1d416d45f64f217704db4587888704dce9473eaec8ffa8d48338e8122cc56951"
    sha256 cellar: :any_skip_relocation, ventura:        "d8f79fa50e6c2d710759a13a1941c4350a0e42ad9fb948c80121369e18344596"
    sha256 cellar: :any_skip_relocation, monterey:       "d8f79fa50e6c2d710759a13a1941c4350a0e42ad9fb948c80121369e18344596"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f083f229f154a544c5371b973d232b0d29e7af2d96531ae409699e81d505cc2"
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