class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-40.42.0.tgz"
  sha256 "3c45aa3d07bff8770d1b49b64dafe9f936f1c1548440b22b921fe3a5b3fb94d9"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b49dfa2822525648186ef190a25697ac869ae53b1eb8b0d2b51e27c74ffeef32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4181bc3a6894195f334fbb101b95ca57542218679a3ef4e8ec8459d30e343063"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "df2bcf905099c732052ea4ad692d2db9b759cf46fc8f2aa1d7eba45f726cc450"
    sha256 cellar: :any_skip_relocation, sonoma:        "373ea297c720287cc96cc229f47bd72a5aabf4fb5eac609a077578cb2a6f66b8"
    sha256 cellar: :any_skip_relocation, ventura:       "5433b59564ee7644c3d0f13ad8b0a7e847415aca08098a3f9af576894bc63785"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d03624f0dc2257238165bc98c9b6c69f6d441b36d1ce78b81cb9bffd8196c68e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49b107ccd02d8508588ec7538ff1e09f23737d4e0d17ca2073d4c771ce83dc1c"
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