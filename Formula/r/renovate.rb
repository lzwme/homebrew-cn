class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.74.0.tgz"
  sha256 "004d263b8913ec34912b15b9cce0445a38bb795a31a33bc8ac94bb84b3827911"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6d5888473cda2ca6760a338439e656be11fec22cda26c571a1e3d64415a6cfd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be19083d525b58f3a04a680b6a4c8563d7f53532bac74e45f19ab882fe6b71c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b9312e11baa038607280812fa7ea6590ac9d6a6535037b2adca74ea3b734c35b"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ca491992a6915c67be3dfd34f7350fdea0d37d406282b259183340c3873c9f1"
    sha256 cellar: :any_skip_relocation, ventura:       "fbae832865f01324ed974139aaea42e9e48f5ec9d00369237e02bad78ac2ac29"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e9bc5e5be62fe99130e436060077765a2d02b076aac048498c4361314b98d71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85fd997d4b714ab706548b089d56032400180654a70dc5ed08c3b3d30cdcf411"
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