class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-38.107.0.tgz"
  sha256 "577321876f6d058a1472905b6aff08dfd31a804b8838bea40e9ee6b434f8f524"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e1f9e5e968729cebd144826d4aacfd7391005ddb2039dcf386e71a27316d714"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9cf1839224ea9bde20e90096370e1e9288f922d5db7dee7bbefc42676f8ccf64"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0bdeb608847ba153e8bd9e547c89d7f696b71774f7586c9d471a9ab4f16db559"
    sha256 cellar: :any_skip_relocation, sonoma:        "f302d2bd74c1a787eac2ab929b42d04c153aa89ff2926f90af1f064eae24449f"
    sha256 cellar: :any_skip_relocation, ventura:       "39eee4867e383973fedb89e7c175d008dfc8e00bd07d8fb0031f33f6518d3bf2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8eee7b75a45b26f87b7c0e2248afe3aac3a3f907782fed726c98d169089f35e4"
  end

  depends_on "node@20"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    system bin"renovate", "--platform=local", "--enabled=false"
  end
end