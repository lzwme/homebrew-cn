class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.158.0.tgz"
  sha256 "d11d4d4074683cf626d3489c15a4bc638e1120afc3ec4cb589e84736b300a152"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and the page the `Npm`
  # strategy checks is several MB in size and can time out before the request
  # resolves. This checks the first page of tags on GitHub (to minimize data
  # transfer).
  livecheck do
    url "https:github.comrenovatebotrenovatetags"
    regex(%r{href=["']?[^"' >]*?tagv?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5cf27ea31f9a017a5227bf692530c73041e662e36c4a5458c9767a1554467dc3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "919b633472098f9f3cd4c5d4f1ff02af71ab761b29cfafc2100114768110b2e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2ceea603f974def1c38eb7d90d9fab1ee01d6690789094eb38fb71016f8c7df2"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba9569813de5b7e88a93de6cc04b6fa2c6b7df3b4c52a54d2631ac648dfa2a34"
    sha256 cellar: :any_skip_relocation, ventura:       "edcb4d46dbe6b8c5ba27b1556053b005dc382135dc2c9716a53dfd77cbb57b3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d538c294d6cb8534355202f3bec0cefa61a99b9d498ed9fa017627d05a8880f"
  end

  depends_on "node@22"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    system bin"renovate", "--platform=local", "--enabled=false"
  end
end