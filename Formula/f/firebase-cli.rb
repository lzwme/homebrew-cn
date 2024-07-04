require "languagenode"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https:firebase.google.comdocscli"
  url "https:registry.npmjs.orgfirebase-tools-firebase-tools-13.13.0.tgz"
  sha256 "7501b91bf04fdd7b5e942121ac90c183bd1a3c5f2ae614be862e6b73da54f2bb"
  license "MIT"
  head "https:github.comfirebasefirebase-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5b1c11fca21230b2d2e5fbbe35efff7df0f8b0d8a516a694f2a165ba93e327d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5b1c11fca21230b2d2e5fbbe35efff7df0f8b0d8a516a694f2a165ba93e327d0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b1c11fca21230b2d2e5fbbe35efff7df0f8b0d8a516a694f2a165ba93e327d0"
    sha256 cellar: :any_skip_relocation, sonoma:         "0ecd6e3a4a2b8b245768540b84ad5194c9659fcfe7e8a3e4f51e0a9df73eb2ec"
    sha256 cellar: :any_skip_relocation, ventura:        "8f8f157583df278d0fbc16bf1578e08f5590e518f322ec92bb236061ddad1b73"
    sha256 cellar: :any_skip_relocation, monterey:       "0ecd6e3a4a2b8b245768540b84ad5194c9659fcfe7e8a3e4f51e0a9df73eb2ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8323a78e21df5d862321e2b25fd57aad1f0067fb1743aa55e11b7f28e25b8e8"
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