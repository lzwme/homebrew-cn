class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.37.0.tgz"
  sha256 "3fcf5c4d055654bcd0e03765686ed5b627edb5c6e752683f8762b74393bea072"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bedc0c1d1a90658d36124fa46a946e843c7d7feafdbe4b31659a75b81a5d857d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f9de39d8a42e0857eb3988a50ce416166ff305c9bdf431f9ebd159600161f89"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "20d7342e0188a2865ec564f11cec9d0cd6287e76642ef4490e3f25c67aec2279"
    sha256 cellar: :any_skip_relocation, sonoma:        "516096781e59a96592cfd949a14d3d7b6ad90ead2ea7684854b847262b94bdba"
    sha256 cellar: :any_skip_relocation, ventura:       "934cde129d1291cc6971ed6ebf8f5e7bed7c86b547ccd87421507558b20a853e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92e732fc63ff5001cc3567f903504b1891007efe32b0cca3bb00c4ba98d92827"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fca1eebee3fc73de46d9a3c0819704a01323378487948ac1a2e5590d9f51b522"
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