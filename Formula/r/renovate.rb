class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-40.59.0.tgz"
  sha256 "9650cc463183f4c9d2efdd3bbe4e109f62db319b993cac1c6840783f6aa435d5"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cde3290de53b6e1c8b0fa0443bed8523595b29f36cbcc4232d5ddb0817f7ac5d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd8b496f2421cd09ac58493523b5f577b475df4903772e77252bb36f2924faa8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8948f659a906d3b0e25abf1f31605e42e8b4ca1c1de4c3b71a9be7d16ad30952"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b97d83b663af46b31472796be2a8346dd449138aa25ed2d6b0abd97d7792940"
    sha256 cellar: :any_skip_relocation, ventura:       "dcbca41d1717d942ab284efb08568fdc85d051442a454723d5bf39f9ceb634f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2ebb869b1c1e5a3e5b120dc8c3fa3f9ed1e2d9b6abbb0c71bce3efe5c860e36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "929037ca209416afd008315d16a54591d175578880d06aceed9fd51cb3d69a68"
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