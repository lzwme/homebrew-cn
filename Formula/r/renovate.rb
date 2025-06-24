class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-41.6.0.tgz"
  sha256 "d0abfb5f277003aa99dcb6e54911c76ae65df1d437d50dd9afab8a694dec2430"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "721df835106765b211604861520b2ea5fb21b9ec1102bace4a882c045fe78a86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d046eb1e97fb137a1621c2487238e92704c6bde9355dda312cea00052d590f1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ce6ecaccd90b00088c8aa129afcd07a8be4c5b2a51f73ed2886882ada51903aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "485cbbcff405b24292c074d013c033c915e276fe7de43995e153c572f479ced7"
    sha256 cellar: :any_skip_relocation, ventura:       "4826d093ee7a9fabbe39cc27aa03d6b39ecb0d991dcb956bf930fa22bf04455d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30723c112998796946b6ade4141e85827c3d338aaa921a32eb5bd4a2f9b7801e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "468c390c5b18f8c0d30e30756e986f76dbbdb8468065d024a1d0546c4c832f1e"
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