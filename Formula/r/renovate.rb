require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.165.0.tgz"
  sha256 "56da17c097d59f5320345a37639827a9c2da010471fd186774a940ef697cef55"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7577e3209290445312c8a96fbd11ab611a20b25475cebdaa3434fdc1096ae8ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d09d5de951b52b8074f4b893e809480f6e42ab8e0d8fe4ea8d1c226c8d8a16ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "abc2d82c54b4e865895d31fa43a355d9b79049819dd3d4ed4b0b5e19d2aa20cf"
    sha256 cellar: :any_skip_relocation, sonoma:         "b9a38278698a69f49ea6368bbc6b4299afc8db7af725bfbac1d0f3b46f0c0e37"
    sha256 cellar: :any_skip_relocation, ventura:        "7769ec5de0d2f3e623aa7589d5353127e84e4fbfac9c5280f3518e1445a83039"
    sha256 cellar: :any_skip_relocation, monterey:       "056f6819bc89ce6d3389c6e829d2885bcfc0e63b952bce395532c85f7afa38cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0555360879d92cf1cdfb89433bbdcd35244c576c780bea81fc8027ddf4b6cb73"
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