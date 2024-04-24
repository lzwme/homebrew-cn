require "languagenode"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https:firebase.google.comdocscli"
  url "https:registry.npmjs.orgfirebase-tools-firebase-tools-13.7.4.tgz"
  sha256 "7478c7eee931842d9192e039b4e77e23741a44577e868be7de08eaaf05f17f86"
  license "MIT"
  head "https:github.comfirebasefirebase-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4146ee1ad0e5952554eb48fe4980659bcb1af677ed00ed9b52859f3903242572"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4146ee1ad0e5952554eb48fe4980659bcb1af677ed00ed9b52859f3903242572"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4146ee1ad0e5952554eb48fe4980659bcb1af677ed00ed9b52859f3903242572"
    sha256 cellar: :any_skip_relocation, sonoma:         "270dd2200f9770fa43631b36cb6fb6115f74375bc9a64e1ae8e3b3130f313bed"
    sha256 cellar: :any_skip_relocation, ventura:        "270dd2200f9770fa43631b36cb6fb6115f74375bc9a64e1ae8e3b3130f313bed"
    sha256 cellar: :any_skip_relocation, monterey:       "270dd2200f9770fa43631b36cb6fb6115f74375bc9a64e1ae8e3b3130f313bed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf9607e03ce677c7fded70c7981eaff970b70e72e5aece0efa72b35b6d0960e8"
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