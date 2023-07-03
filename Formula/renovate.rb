require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-35.158.0.tgz"
  sha256 "7075694073d47e8a0aaa6155a8f68d81c4b04506ddeb1649ad40e9acea19825d"
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
    sha256                               arm64_ventura:  "84edf49551cf89c8aabeecd1039429b8c91f30be7663a8bf15498f93f5a2482d"
    sha256                               arm64_monterey: "323896aabf55989b7d8786e9fc7b493607218e13168948ba57d6e91af89d366f"
    sha256                               arm64_big_sur:  "3be000cf0afdced5cc02d9733f24dcf710ee41cb45d7cf10d1947e55cfa4e880"
    sha256 cellar: :any_skip_relocation, ventura:        "e2ad33dba86bed16b445e561d4879a2f9b4c7ac36e72591a1f01a65d9eb38074"
    sha256 cellar: :any_skip_relocation, monterey:       "3435ebdd379b0e56c7836f063ba14cbf6550a551906867c2fd118a7d3d0068e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "ff2434488f3d487e9134e1b0fb715286826e04c32f585af8856876d0362564c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "067981535bcce86c9af2df484b812cd0e84e80a3225f9dd34cab3fcacad12e6b"
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