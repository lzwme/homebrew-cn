class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.238.0.tgz"
  sha256 "2162a390aa10e0a14654141c2eb6ba2351adf4f12637fdadc5980657fff47dc3"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f95ae340fe99c11f16ed0af72581fee2cce9144b892d35cab81fe3b1012d978f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71574bb080e746b5589e658be76093338b4f58d93a053518f20214c12cb6a8c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3119ed5cef2648bba60a581d0dd755db09a726fd0ae584a359bd298c04efe647"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b1a4e90e19bc930cef2db331e1aae99d71e30608f46ada3b3d6921f6d9ee5c8"
    sha256 cellar: :any_skip_relocation, ventura:       "dfb8ed7087394b8bc161b90bcae6f1148dc5b096bb8bfdf84c909be0bb19d741"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8843d0e0645757115b12c41dcbe8bd7e8eab0a31031540f9b60753c0402dd23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce7b89335e1416a81abf7f4ec92fbf5f946b06408a862a23532f4a3c784ad3cc"
  end

  depends_on "node@22"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    system bin"renovate", "--platform=local", "--enabled=false"
  end
end