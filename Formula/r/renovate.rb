class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-40.40.0.tgz"
  sha256 "b078de8c26014457fd20a0b54c8a6c20b08b0ca32a60399e3376b0bd67794843"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "faba07abc4b431bf5151f49c53b78a5f308eff6065d4b6b5cd40204f4f086192"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "423b068b6e8ee5f8ee1bc3a7f74080b46e1f4f7c4ea16617bcfda348f44bd990"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "779909e93b122ac5511d2cec4bb34e864831801fc0db223a1cb14f2d474b513f"
    sha256 cellar: :any_skip_relocation, sonoma:        "2534e60836a72af52bfc52902e26e6aebd790d51098d25245a73562bb8217aa6"
    sha256 cellar: :any_skip_relocation, ventura:       "66e5f0c2bd19d801aa9d735e7fe65dc1b5781759b91d28938f07056f5557502a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "509c10ee58c37c3f187adfbc48793c369c7a0729620171dc01d25842836d594a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48427926c9a9acde2b9bf78bc4e659f23193c83504f4a30209a73a8a9cabc061"
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