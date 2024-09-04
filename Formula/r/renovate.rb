class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-38.66.0.tgz"
  sha256 "61bd3456349ff7159eecce8e37b8edd4809af3d2d5b1511e8fc0c5326467cd69"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a88f3ead5e3d3e356da5a073fbea308aba28436505bebaedad8cb0b2bb78634e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6467893c0ade7da7f0e73e08648f879e735c834f2185dd5468be3c3d8ed0913"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ed164b93d7adbde87053ee895207f072abc07d22128fa26c10f3e47bf1290ef"
    sha256 cellar: :any_skip_relocation, sonoma:         "9989f0ccfe15b215fe5ab2191af9343e4ef69b5121ada8ce99628ac01a891405"
    sha256 cellar: :any_skip_relocation, ventura:        "cce22920182456101bfc291d4c7bea517f8a5220088c3215e70e92821cd6e39c"
    sha256 cellar: :any_skip_relocation, monterey:       "3003c99309eaea08a5385c0b5d8fb1d9acbfa93fba07002605a758487e476b76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08409b17d0c144a889279923dc6b475bd95c62106a463295ee80a14868108b95"
  end

  depends_on "node@20"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    system bin"renovate", "--platform=local", "--enabled=false"
  end
end