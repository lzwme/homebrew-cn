require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.37.0.tgz"
  sha256 "e363b7eb53041b321b5b26710d832ff120af9bc3ab8f69f52492d24b4d99b8f2"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a805ecd4c5fa4917198bc7363f21297a2d9dd392962e99e201c5cfaded855b77"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5dbe77074b58f6ebfead072c7d6f989afb53a1a94fb2931fb01e213b109c85f0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a7e00562226ac99c49870e8faabc9a6083ea3b74dcc251edeab11dbac2f7cf26"
    sha256 cellar: :any_skip_relocation, sonoma:         "4100b91f2dcb4a91670c101cf37c749c4e9691f6d3572edf118e4a732b6dc6a0"
    sha256 cellar: :any_skip_relocation, ventura:        "588c813f74305dc66d872a63179df589459cb6caadfe5ee0eda81e30a093438b"
    sha256 cellar: :any_skip_relocation, monterey:       "efd63f037700db913bc4d3d53056d2cdaa03b7edbc5289982104a860fe2f3162"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3836a254af56617155c3f8c66085a727fb39c0968b62f6d37d7e433dc3e78418"
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