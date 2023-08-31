require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-36.74.0.tgz"
  sha256 "ad8149ae5a086130d433da58301c80c3046731e685233713b147805779dc7de0"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6d15683170b06db018eb94c21d0d6cc2caab1b8d89beb8b28be768eb2b669e83"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a72ffc74792f787f7412ef21054f6a3607992c5fdebe32db0682e0a35d4156c1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ebbbe008408b8a59c6f4e4ac18d04babb49e47eb64e549ab73354180c198d149"
    sha256 cellar: :any_skip_relocation, ventura:        "3dc651fafa84bd12cd8ac969b9d35b5b3e529cd14dec2775aed0ab2f95c58b4a"
    sha256 cellar: :any_skip_relocation, monterey:       "54c63bef53b89cc9fa59833eb087ef00ea047276ba29181b243a384ca3993b1b"
    sha256 cellar: :any_skip_relocation, big_sur:        "42f65168e649637a31cc97791b5205097d5248c27d028af13392c967c1b280dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "592218bc0012ecbf2e16d62f5dadd015e556ccbc2994091e7428a478d88cc7d2"
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