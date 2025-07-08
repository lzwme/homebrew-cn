class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.24.0.tgz"
  sha256 "0ecd2b049ae8c4fe337b9bb66b2fc84713101d31db9f1935ecaf41d438b8723a"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c4e4b6219f6e0fafeb3055e8e71fe417617d9c29adf1ce9f0554d9d968d4e1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3ace852eca07b37a6d95234ea827d019d5fdaf792989280a19f5600fbbe62f0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b5deb18fb85ee6722e2fd5245e012f5b13fc3861337c47b76163b08fa50642bd"
    sha256 cellar: :any_skip_relocation, sonoma:        "99076f1cd7ab42fea8be869f40726116e20e8b614a78fbd1671b275f66d23a5c"
    sha256 cellar: :any_skip_relocation, ventura:       "4afa741ac465a50d64fcd0137dd475b9a0b89703dc744da86d986bd99c78b1cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab7645e402f5149778a82abc0441f9b370e0b354bf6eb2d37cabb912e0f6e741"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd4d86c9336d82cc2013104bb77f510b3aa09763afd732b8922b51a9c6bda5df"
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