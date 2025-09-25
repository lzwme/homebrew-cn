class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.130.0.tgz"
  sha256 "0727bcfc95c6b1df360295b377b7a041fa52b3c774461519d972027de3842030"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b0d47eccdd125ce0f508a0cc442545fa036a12df00269bb73467a7110ef129c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "104b9b39f6ce5cad23db7c10d0b65b22868bf231f61dccecd2b49f38542493d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb78054caee544d801936ffccea89d0d95db50077d16667b61558f39bac8a675"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f2bf4670abb82d655278a254f390c46279bb58d7c201b5f430f0ffd5172ec06"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c95ec3364f41fe57fb4b2f28baef7a617aaa7497d39ab29d34964e5b14b85b4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f955d835e9b7a558cdb7adaa30f3eebb222139ece6554327c834da5a9dc4fb3"
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