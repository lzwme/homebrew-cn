require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-12.9.1.tgz"
  sha256 "d3f6037c06bb41119a053013870ea05f866c0dae98aae71f415c53eed86a4b97"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6c8a3cc59ad8175669db9445ed4067b93302b5b65bba3dde1e6a512c10dbdb67"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6c8a3cc59ad8175669db9445ed4067b93302b5b65bba3dde1e6a512c10dbdb67"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c8a3cc59ad8175669db9445ed4067b93302b5b65bba3dde1e6a512c10dbdb67"
    sha256 cellar: :any_skip_relocation, sonoma:         "27539d55a051f497c15177fa34d66d149245e29dc23f79e58fb0bb7130908d98"
    sha256 cellar: :any_skip_relocation, ventura:        "27539d55a051f497c15177fa34d66d149245e29dc23f79e58fb0bb7130908d98"
    sha256 cellar: :any_skip_relocation, monterey:       "27539d55a051f497c15177fa34d66d149245e29dc23f79e58fb0bb7130908d98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12986760f50d34e2da79fb8ea2a15f7108032202ef97338486511fa499aeab2f"
  end

  depends_on "node"

  uses_from_macos "expect" => :test

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.exp").write <<~EOS
      spawn #{bin}/firebase login:ci --no-localhost
      expect "Paste"
    EOS
    assert_match "authorization code", shell_output("expect -f test.exp")
  end
end