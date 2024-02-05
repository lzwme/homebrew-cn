require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.172.0.tgz"
  sha256 "e814914f8a248efaa3e3c7ada80e9a7439c8ec5e70a4756cc1c96ba0ec884c11"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dd7a5f9e875451449fde40cbd68dc3b125288ea3b65267ec7ba18e3e9c2411b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d168fe470c97b367ffe39dd5a916263c67d962d587dcb9471a04a6a0d112cb17"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb4f24850862b7b559f822dda6025e4bd84b8f147efd7b76cff63cf42aa7167c"
    sha256 cellar: :any_skip_relocation, sonoma:         "388ef1e65848f3583b57607857d024456106ab1ce0a5485c552e46131d04c56a"
    sha256 cellar: :any_skip_relocation, ventura:        "87152f144a90e11e375e670ebead0117e59b933e87a2211dd4f8ed2a0baa526b"
    sha256 cellar: :any_skip_relocation, monterey:       "8f9abcfe396b37497be1cd383dc2536883a91ba0606a46474dd303a077babd8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b34f74d75a75f6b49b4b3fd17a3eb203a9a01a6cb49144fa7690314b9e49c31"
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