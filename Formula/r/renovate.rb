class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.59.0.tgz"
  sha256 "f842df007191db71f2193deed9fd2570bf7d11b479ab0b2ec425b7ab96ae6800"
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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d37b2942c4c8da431b6adbb0ca0dbe77d9d79860fe6ac2b8cc85d973d2c1840a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2654f5dcb8689a74727aaf6c1705b65bb0648bf9253a9412059c052ad9302c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5ddf361cf3e07ac9a886acd4ff6429f16763db28b4dc15ae7918f83cd07c2a1c"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6cca91297b344c3b998157f95a38ec889ddfe578b7c65bb9ebe2358c9b6367a"
    sha256 cellar: :any_skip_relocation, ventura:       "23170ba73b9cb04734b321a1344fd98e13e17d8ff88338cee8ba1ef2ca34447e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "605218ea662b3f7d309f09b0fc20d62c2e5a475d92992349d50a221d124ab27e"
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