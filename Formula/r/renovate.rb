class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-42.11.0.tgz"
  sha256 "ae4e4cc79caa39805a192a7be26a567114bfefa42af3f55545e3020c10fd7a76"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and the page the `Npm`
  # strategy checks is several MB in size and can time out before the request
  # resolves. This checks the first page of tags on GitHub (to minimize data
  # transfer).
  livecheck do
    url "https://github.com/renovatebot/renovate/tags"
    regex(%r{href=["']?[^"' >]*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e0a7fe47958be03bf3d1f22c35017d56ea3cc8f896b119b7b4912f29d4c2c180"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30869e32cab52da8d27fb80683f1f4c9e95a9811245874d2fb52730f4916842e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8600ca129d0cb1e651e63547314af7b62b638d0d89d1617e2dd52b9b6c7d7224"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6662cc07d6f640dd7b94d488adfe730bd500317273af3f1b09e170765b1d1a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1257423a25f2c8ff8a6b2d24b1bf038d96a00c0054aea98f3b890781ec0a7d2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b1ac63d08d198df1907dce07b660a976abebb30a0efd278623b5c0e621d0c10"
  end

  depends_on "node@22"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"renovate", "--platform=local", "--enabled=false"
  end
end