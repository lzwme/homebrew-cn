require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.43.0.tgz"
  sha256 "d0dfd8e775f853c7a655cab4b3de1931db75e317e0bfc6e64521487b26f88aed"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ad7a8508cef9fc086cd5a29c5d7bf460848f7a47356b641600d748e8b8145361"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9ded44cf78c9984fbee7394aea16135a471931f6db9e2f9670c425b3ee815a0b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d31bee15a8360dc06bdbcec5ce4bfce3da3465068d9d7f6d8c9aa5084713e72"
    sha256 cellar: :any_skip_relocation, sonoma:         "439898c44e9042618d1dd5cbe5d79329789c8d4c7d44aa87b9eb2be9b6a4db82"
    sha256 cellar: :any_skip_relocation, ventura:        "eab5f87e7bd8c8e0486d862e0aaade8051421161c933a74c19dbf754f0c658b1"
    sha256 cellar: :any_skip_relocation, monterey:       "7b23ef95de8d7f8647b7dd7602ef3779293f28fe9012f98b11abf6f6497d2231"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c192265f1556672ef0ad5df11ae850b23a20afa890a08fa52d376095ffa21f55"
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