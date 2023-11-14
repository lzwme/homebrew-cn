require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.57.0.tgz"
  sha256 "c4f564fcb179f6397430322fbc55ee00eab6b90908ce43849bbd1d7b96d21686"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b0712ce35208f970cd1e8a4c0d866ed229a3e0298e8c20c224b59c3e26b10a90"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "efd4a510a63705157670c6fcb3fe9447f0fcf398fa80ef1edae14b4950dd9964"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b77ec889f02e13ef66a1a329119c976b9c9e0bdd15f8f7201875654a7a985a03"
    sha256 cellar: :any_skip_relocation, sonoma:         "6fcf81aa7c2cc5221f2efa1420c67bf7b0edd3bd509e1369036eb0b68d6d992a"
    sha256 cellar: :any_skip_relocation, ventura:        "4728f3b3df0016ad541a79a5032e45f326edd60b3cc8040c2941428aefe164a3"
    sha256 cellar: :any_skip_relocation, monterey:       "301c0ed1c37a45681e8989efc7f26cbb18dd3e66599f4074e2ffca53cd658ac6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbf11efe7bfe8fa3301072279bfb807b217d87e34dff90654b6ad4495b16e685"
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