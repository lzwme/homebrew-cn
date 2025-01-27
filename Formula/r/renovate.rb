class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.134.0.tgz"
  sha256 "e9c7d6fd3b3d56c5b13ab5c76596a25fe7e44d6940eb52b4e2740c2b98f08cde"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7063a722940793cd92d49ece1d858d3f7587fea0b86f4fb461b65404375b9c8b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de3ce0c1fd513f79d4e44d1b804aabb8559844e68a0b962b3697a609382816bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f6168453533aa23041af3ef176270b1ad18d932646555a9e8c59d64628c644fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9393b7f35abe09579ff9c9403f458934edc91099e90ece7da7c54cd699b3918"
    sha256 cellar: :any_skip_relocation, ventura:       "e67386a34d714c89b22659f47ad684b20f5ae862b3a75f85fd047eb3b9fa4f8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aef6cdb5f847963677ebcbfde5ceec0c140ccfc43c59310429f3b0de476ca867"
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