require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.192.0.tgz"
  sha256 "59638bcf8f9c5c9b66cc7841b9d31114fcddeaeadf86be7e2a704bb347ef6ffd"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0b62910d1c556f0979d0f6618d347eeb73d07c33498aab0c14e1760521e02852"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6eb21e21ff16601c2de118d7a0f6fed6ee73551d47e199f2bb397fcd72d7b0c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9371852a4344e9343d44edccd011a052a43b07c2500bccc57d316956b1b19ec8"
    sha256 cellar: :any_skip_relocation, sonoma:         "7fe462b33dd4a77dbf4d36b5f940a90af2b3d3a6563548db8eabaca514c66c4d"
    sha256 cellar: :any_skip_relocation, ventura:        "948a877b4e4fd7d219616439cad59a81586a7d65beb27e66dd9d310d07ddaebd"
    sha256 cellar: :any_skip_relocation, monterey:       "3137f49a34ffdef102d02ae259b16a3b70f692c43f7bec5abbaca81cc1c42304"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31195d56961d3b5d3163aab86bfb513ef91f86d938bde15df9b9c7d61be988e4"
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