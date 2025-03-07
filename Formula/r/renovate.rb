class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.190.0.tgz"
  sha256 "c5fa5f1d7bfdcfbaeb73745ca8830bd3c757fa78976ccdee0c47cec7109a6c00"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d78cad8f6d4fcdcfd0a605c143af73d410d33accba0f4ae7f00c4953e9fce32d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "947b04b9855258786d321e9665afb56e2bbe4b8e11a3f37089d5765433a56770"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7637333e9f0b7abd117e67172caca078a904349486a9e2a4c5e234d016300e3b"
    sha256 cellar: :any_skip_relocation, sonoma:        "83d7e17d3e1d067126294e76b4caef09f61dd77c461cf5c1e47971951dfe3662"
    sha256 cellar: :any_skip_relocation, ventura:       "a2a84f2cf7ee3ca1175e5b5032bb5ffb497edfda2b4e442cd30643e90499821e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c734d9472fd9f014459ea8fe9d7e38e8b8d72088a45a6189762bf3eee0f9f57"
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