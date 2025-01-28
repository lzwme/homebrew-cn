class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.137.0.tgz"
  sha256 "86e553880af378c1a4f426a617648522fdf15ad97f054115163d08ce5093af5b"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a6fc6f1d03992c6b654aa21453133a813ec9cf55920bc0260a9a770eacca69f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ac7754baa6e789316f2c4a91fc94458ad2603fc55157598e91ab62ecd884f34"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a70aaddf06830cea2566b48aeb4ffeff7a1a6ba8fa016456dd62b614aecee0df"
    sha256 cellar: :any_skip_relocation, sonoma:        "302ff2adf41d6e83d6aa95e268b8aba34c6044e5100300a5da6eb22d7225758a"
    sha256 cellar: :any_skip_relocation, ventura:       "3efb5d2bba24560b930b3a05d708ea44469dd9bf2c174f3a8c57a661b0ba8340"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f73e295106b566c18a862562a27024bd7ccbcf2c6006ad13a072ee01b10c9cec"
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