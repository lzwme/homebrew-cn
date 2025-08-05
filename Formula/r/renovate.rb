class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.52.0.tgz"
  sha256 "5595a6fd4be8442e5b196a979810bf511c9891e3633b6234effe9c362c23db8d"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c13bbc3804ff181c98f24469b623825d353c00bc9a77a0629bc743810091f95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e4034cf31d2b8d20ad29b9fb96df71ee3d70ea157d6014e6447cdd21d1eec28"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "66bc956382ff3f35ca446e6cb7332523bc6aa2fe18a8283a9ba2ea5cd53fd0b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "98801d71a249c228fd2f694fd8a76160bbc983ce2811d1a88a7277b410294af4"
    sha256 cellar: :any_skip_relocation, ventura:       "38207ba23ce98d1115ad151398813de304587237273302ea1532e201d1065d8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "908947551d9833f7dce96b6d0364b31b1ce67ae72c6f2f3498dd79cc24b6210d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86aabb87d0fde6ce876b233306a86fe0b5f3929db9fad18cc5939a2ba4861b3e"
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