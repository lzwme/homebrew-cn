class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.103.0.tgz"
  sha256 "f443d69cdc336537cd04ae8a4c7335f4e981b233cf172fdfed0a8cc37f0a8d71"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d2059cc0d51bce1dff7406c48a5e2efbd7cc1ee9345e612efe76709c4aff0d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96cf90a568f9447480a760f72ed94d739d71c427ad4385e6b480f90808c8053c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e83e1fb313fd5831158e01a54d3f3c66592e943893f8117af4bac0855339929b"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b3a6d0ab51d146ff510caff507ce7817bdd3bd900c7fdcd54b95a8b7f1a0e32"
    sha256 cellar: :any_skip_relocation, ventura:       "e0738c07af42632fe134b2894eee7f22814b1f0376cfc1c042a6c86a87825bcc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54107c77a354de2fd84fa1350bf6506bc210cbd96d35e53a31ec48b268b548be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f559c17baae424886d7318f6bc89f2a49bb1fe7500c26f234c0493ff581e6f1"
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