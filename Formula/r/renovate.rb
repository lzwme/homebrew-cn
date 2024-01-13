require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.130.0.tgz"
  sha256 "4f64b640ee04476a83092ca846dd8695fa9379ef58afae95c79461da58c0466f"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8abed1624731a99805c5e96e4bdf0ea8c995f89e0274e5187b5039a3dd8123f1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6282d9ebaa6e00c23bf490032fe0ad4fab48808b135666a451a3a54da8667c61"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab1db47d8e4490a9f5688a1f3206d04a45e82a48beac1edd9ed51c344d0e54a2"
    sha256 cellar: :any_skip_relocation, sonoma:         "d5c49e9a3f6c1f0b7873456ea30d86f7958a967c029ab431d7f4172734046c1a"
    sha256 cellar: :any_skip_relocation, ventura:        "c3e6dec2b6e0ee0a123339d5f3b3fa6222d5af6546f5e8318afff11048a8af36"
    sha256 cellar: :any_skip_relocation, monterey:       "19ff4b5cc6145ee4019119a2c79777a5637b21f56bb2a03b3c60040e15c04330"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a133209e8db90035357d6fe2f2dc244c6a217356af9d140860b1af16a1298ed"
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