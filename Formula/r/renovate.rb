class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.99.0.tgz"
  sha256 "327e6fb7602b10dabb8c221e0bc4434cedf524ca65e2cdd29619db5a2b417b7b"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3131493b8e599f9662a38c70504e64c75b98ebf586b357b772e1332450eeadb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8792b4aec6d2a0af4ca4a66cbfc0d95d58a3e5ed291ca1d27238cecb991f6b4c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9465e46e50378d46344d3e643317655dd3c901e8baf6f0293fbf0f99b1d324e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "e368bd71985c530f1f0e7dffe4a426ca507e1f2adb09c0a5b02a132acde39f4a"
    sha256 cellar: :any_skip_relocation, ventura:       "ccdfd4d7edc9f15950d889fdfe9594c923ceedfc3e8ac8d885326b2013cf0260"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "778894ed1aaed9436ea879ab07cce64aaf9768d7779394e2d66d8d69fc27e806"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ed4db14da6a7a59da2fbe12e9cdcba0515c71e5740984a66830737aba3ef3ce"
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