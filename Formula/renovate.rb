require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-35.110.0.tgz"
  sha256 "f502aa3c37cde40d3ed789225d662e72bbf720b8fbe3bcd5101455e9fdd6c2fd"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and page the `Npm` strategy
  # checks is several MB in size and can time out before the request resolves.
  # This checks the "latest" release, which doesn't have the same issues.
  livecheck do
    url "https://registry.npmjs.org/renovate/latest"
    regex(/v?(\d+(?:\.\d+)+)/i)
    strategy :json do |json, regex|
      json["version"]&.scan(regex) { |match| match[0] }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "41e633fccbd56aaca80577385d76cbaf7cbcab6389d0b71065dca62ba474f1d4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94f5c27dde1d43bc1270f3f0db747adb1d4cac80ff75aa2fdac1f678784a460d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c7690794fc24fa32f026d226295d3d028bc89c5bbe88d011674ddbb45a200520"
    sha256 cellar: :any_skip_relocation, ventura:        "d7f14e1bd0dd96270e494d34836a74f734a4c22801822d0a3776e5421df93ab2"
    sha256 cellar: :any_skip_relocation, monterey:       "d68dab7b28076fd3d81d114824a01d1da8af8387b1ea32d713a5b1f8e02435c9"
    sha256 cellar: :any_skip_relocation, big_sur:        "37ece410c06bf26592e618b0b0280ef43f1d2efcf9dda7d79bfd58139f191ed9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34c1377be2acb6a2478d993f179942123815a917419f5d0b1856d17e55047fc7"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}/renovate 2>&1", 1)
  end
end