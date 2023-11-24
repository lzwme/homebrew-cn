require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.66.0.tgz"
  sha256 "bfdacf1c78ebd564cd96f63c4d633c7fe58ca8990a82eb4a9efe1dd179e0b614"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "554de4569ba60763b4d6efa91a81f05c2381e76b832992bfded8ffb5c806074a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "14e844b2d38d4dfb297b91a331128f0aef10db1b478722bb65534824ff3f30d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee2b37493edec6c7e0c30b08b1e6acd93e1608a714bb890bbaf40b3034dee5b6"
    sha256 cellar: :any_skip_relocation, sonoma:         "b73de7073ad729587ee1b2d6de37bfe0792f24f38594948af058e199fe69dac8"
    sha256 cellar: :any_skip_relocation, ventura:        "d95f2503f3e9be7bf29cc5580af9ae389b9d39ae0e882e9ea8654800848d6949"
    sha256 cellar: :any_skip_relocation, monterey:       "906d22091a0235f653ea3ed950850738a556608eb437bb694d4bc1c3e05e50e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "579dd7cab596ab07f384351f0ac65a6e3407c63a990e35c57a7841cd4b6d8f27"
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