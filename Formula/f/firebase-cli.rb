require "languagenode"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https:firebase.google.comdocscli"
  url "https:registry.npmjs.orgfirebase-tools-firebase-tools-13.10.0.tgz"
  sha256 "d9cb666dcddfc562c5e2e40ac1bbbf08ac8ab5801a994c9e9c85bf94a0d4d594"
  license "MIT"
  head "https:github.comfirebasefirebase-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f867afd84348d7f23bca2396f107412c836fc0e61aaa1a0cb3f2c0da170134ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5ac61c3017b75e197bf6bbd527dd9067e53d55f203444e6024905253d91b2810"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "355d02bfb414f9186655b9f2eb61de8b0b42d00036af8a048c78384360e83af4"
    sha256                               sonoma:         "b5f0230da073946a61d10c7d197d7547e6e572a21edef560b4edb97236dbb0bc"
    sha256                               ventura:        "c7c617a5f4dca79a00faff37050b47152a78ae15ddf2e9f917b2d68fe454fb10"
    sha256                               monterey:       "5c750f92e83bb9583feacfaba6c589e95f0587d0f3ccc89c5bb521c8b533cf71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb40a620b22c59d2597a58e46b580aed8372c5b4cf2927e9822e27165f2ce395"
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