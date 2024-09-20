class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https:firebase.google.comdocscli"
  url "https:registry.npmjs.orgfirebase-tools-firebase-tools-13.18.0.tgz"
  sha256 "f6f8121aadf5d912981464adad1e1b3c461e92c18d87346d35315ad38302da44"
  license "MIT"
  head "https:github.comfirebasefirebase-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31953b72c1bdf7722ca7e56724e9ba5f5702569d2fc89a764634c5edb4beb0a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31953b72c1bdf7722ca7e56724e9ba5f5702569d2fc89a764634c5edb4beb0a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "31953b72c1bdf7722ca7e56724e9ba5f5702569d2fc89a764634c5edb4beb0a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "64ede552eccdee76ed3ab63c64c3257d3f3e60d1c3c4ddbb212b38ceb7f99a17"
    sha256 cellar: :any_skip_relocation, ventura:       "64ede552eccdee76ed3ab63c64c3257d3f3e60d1c3c4ddbb212b38ceb7f99a17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "111bc99baa5f6628eb317578237b438fa5d5d3282ab88db9bc083c16dce96e72"
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