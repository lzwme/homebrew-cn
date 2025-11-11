class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-42.5.0.tgz"
  sha256 "6fed631f1aa6d87c7d2d10a0c4586512e900a9ce4515ac6905e13b9a0188611d"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "055aaeeb4073aa3c1390e6b065d34b99c9a9cd78cc686f4e69bfd2fa1c7b4a62"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc70177c71b740bb5fafca8e3d949acb6ce782285279011094fc440515764f30"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8749db4f89f82ab9ef41fd47cd4c78987f195e7519b044d6871a5ce67188ca60"
    sha256 cellar: :any_skip_relocation, sonoma:        "224ec2e880cbe14c4ec9c68961b005857dcb1f3d31a1cfe1f35ce72cfe6d51f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed9ae02cc31dc6a62ae4ffe90a07f2c7a53c79ee3b4bd48b3f3e73ebcb37120f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b5c75d41e8e433e534ced5f870cbe1a66a453aca183bdd26842e1598ac079e8"
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