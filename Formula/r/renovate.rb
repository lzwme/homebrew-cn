class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-40.25.0.tgz"
  sha256 "efa8a44e395257ccfff0bdb3c65bf5cd7470bbc2b9f255a30312e91ae5c621e0"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df65a0579a129df62ee2f969e56905a5b55936508198a13fa292780169591668"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f26ec1135516c53a31bb89d5c97b28f052555a9ead7ec234fcf8fb10337838c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "105ddc6ea73e59b15daffc0041f3a907fa882c6f1042fcdbd07c3b2f862403d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "02e105d5e00cdcd0edf90c8802c7f21969262514e88ab12ea17a4bac04ce453e"
    sha256 cellar: :any_skip_relocation, ventura:       "3112cbf9f9e8d80d1113a94105bb7a95e19ec0c9e9e58aff7e81cf577ef5fc9a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0893719551891c5936419b3bab93f071cf4aa16df3b9a0ebf2ee85323fe94944"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "672b08ed3717906a7c808fee6219866779732e12503049deea74a046e3a01f6c"
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