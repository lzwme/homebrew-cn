class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https:github.commongodb-jsmongosh"
  url "https:registry.npmjs.org@mongoshcli-repl-cli-repl-2.5.2.tgz"
  sha256 "37f69f3a43968b2b7fe29075c68d2dae922b19ef573ed448ff4166108e0345ed"
  license "Apache-2.0"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256                               arm64_sequoia: "32289189aa582229ced4f80f2e79f4e207e81b0de86159e1e5e36397be19c055"
    sha256                               arm64_sonoma:  "2165625b1a75d8c78fc2aeb960a120603f2f779d82025d2c11f82a55b4146bbc"
    sha256                               arm64_ventura: "ad2ca6e8ef371d7de6e009e31b2572f5997546266c998109bc7105a8bd7a222b"
    sha256                               sonoma:        "5f25e8dd7a1a321f873f7776929c59ddeff6c5a954bc0d5da2962df5a5fc25d2"
    sha256                               ventura:       "605b685c17e59c8cc3f6a8101f5126747ac8b55eb916c1e4beea18f13ffa9b6d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5bfafa398fea8718bce765e2ad707e0f402a8e24fc3878ac5f47ae92e9b6963"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d33558bdbc3eb0d6db07b47d1851b646e1e85bd1c0ac9b666647a13718eca5cc"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    assert_match "ECONNREFUSED 0.0.0.0:1", shell_output("#{bin}mongosh \"mongodb:0.0.0.0:1\" 2>&1", 1)
    assert_match "#ok#", shell_output("#{bin}mongosh --nodb --eval \"print('#ok#')\"")
    assert_match "all tests passed", shell_output("#{bin}mongosh --smokeTests 2>&1")
  end
end