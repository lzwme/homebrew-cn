class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.126.0.tgz"
  sha256 "c667d4e2d4fdd35d6857150c78d85678c775b99554c1f17778092dae1379f9b7"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c35038e7642096f8e8f4b90a908249f5becf09a5d64ae00b014305a16a1b8bab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac03516d490611093542fc11fcdb8fd17de9deffa03ca53f4c62f02fa2a4ba55"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c642a0bb3c1977dce0048f6ecaffb36e8b09f6e1668b16754d40831a0679d3f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "f0af289414680c486d1230412aaa8c196f856dd90a277c29174b4663c1562ddc"
    sha256 cellar: :any_skip_relocation, ventura:       "072999ddd46d42be4e06b3d7c226281a2329ab6bb48dc5cefd055b02ba3f3457"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe85eb4ac1cc120e7a9b8771489d48ade8a5fd705c9a015bebc9fc09486b8be2"
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