require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.340.0.tgz"
  sha256 "4768db7adc4a7b43f97185b0e90b7a62bcb55c73418299834969438abe5e8d39"
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
    sha256                               arm64_sonoma:   "1901834bc13012664f8e1f8d9fd9a376496dce509b0f29fd10cf16d38b68d31e"
    sha256                               arm64_ventura:  "ea9475671e6d0be317ed3d135baa1970153184b85084a2933ee1cab708444fd8"
    sha256                               arm64_monterey: "87076f2110d23e65da25f538cfc43adfc8633677c5582491b777d045c28255dd"
    sha256                               sonoma:         "9b4dfef5acedaccb68d986743dee51709af4162f38ba539d28e4615aff258de5"
    sha256                               ventura:        "26d704b163e223854366d0712a00f89823db5dbe52c60c69efdb1e9879861de2"
    sha256                               monterey:       "795de79f4b91932dda9aa7506a90b5c3185223d0c97a96d933d254ed561db118"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b76137be634c0ad74c73c3760af77435a04b0d4fae7ba3b5a0084b9c8a290522"
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