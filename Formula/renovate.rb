require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-35.124.0.tgz"
  sha256 "be2389dc6b854f55bc70f790008a1223f17895a2be2c8e5146d6fbdfa964792d"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db199c017db278d5a1b38a08611bb8394e055325e7dbe2e373fe3bfb8f56005f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "280200fd825635ec0352abacfe9a12cd0c10ddcb266857219f704703bbdc78e6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "10f99a7ff15afef6dd07ad898dc8f381f4af1e1372ee34bad634dd1b408a787b"
    sha256 cellar: :any_skip_relocation, ventura:        "9281072f07ee26df274229c43922fe7b0b73beeed619c5ef053dd53b067bc06d"
    sha256 cellar: :any_skip_relocation, monterey:       "491e40dfe9f861fd7e49155ca1b0aad7e03067d481f3fd93bbd5fdfdced6814e"
    sha256 cellar: :any_skip_relocation, big_sur:        "3e639797661020ce7012e3ab007d399b3610b9ba9ebb70e6208836c285f26af8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5bd5b1eaa725ef39bf11c23693ebaefe5875cb0827a13168045644f82e63a044"
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