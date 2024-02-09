require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.177.0.tgz"
  sha256 "d22c4fe4cc4507a773fe5831485935fbce9a876a6181d62f54484e752269d677"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and page the `Npm` strategy
  # checks is several MB in size and can time out before the request resolves.
  # This checks the "latest" release, which doesn't have the same issues.
  livecheck do
    url "https:registry.npmjs.orgrenovatelatest"
    regex(v?(\d+(?:\.\d+)+)i)
    strategy :json do |json, regex|
      json["version"]&.scan(regex) { |match| match[0] }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "efc2e3fdcfb955e72853cb4d5fea328c53a7e2c249e9a251425d21c20f29cf3d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ed2db2ce54f55ec0b568f9ee6acaa5a659a19f3ed9ce5008180ec7079bb9c737"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba40328c3c8caa70a1031061cdba450cf5bde3da330164f0c1d69c8a07e86ee6"
    sha256 cellar: :any_skip_relocation, sonoma:         "2f7b738f5208cb4a933be475c6e21c49536e65ac13049c87c7aa71cdba377737"
    sha256 cellar: :any_skip_relocation, ventura:        "3d920590af4765f8bf6c54f2d7b965c32073351cecfa14f40ee68d5a5d5ef3d7"
    sha256 cellar: :any_skip_relocation, monterey:       "234e9c0dc0da811a100767fccd598db5c302bc17f00a3c40a410bddd7aff7b57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ecfb57b82e659f92a9b9aca84caeb82203110526e84253f910984650f4798bf0"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}renovate 2>&1", 1)
  end
end