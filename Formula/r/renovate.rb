require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.44.0.tgz"
  sha256 "06ab95d0eee6aa35ba5247915ef76b1a313e3ea58b90bef02ee1ec85d412da6d"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9a0eba907839ff5dc0abdede2417a871dc8500db60ab91381920c7dc4651c459"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c442d9f65b967fde2d0e66996981fb13ef64121c13a490c5405f06a7f65a97e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "298520524f8101260f3148eb04672b485d6641d122ba23d3e96d1e6ccbacb2b6"
    sha256 cellar: :any_skip_relocation, sonoma:         "c182656b0b4f31a8fb01430d962a2da0d83cff162036807f56df9ad7ef580820"
    sha256 cellar: :any_skip_relocation, ventura:        "654e714e591409a1dfe93152d6c785e96eca96a629fdde265eceee8c9473f185"
    sha256 cellar: :any_skip_relocation, monterey:       "105009a63c4fa7bec15592af708925dcdec850bff209ab375a3499b719e90db5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50358b6ee1a24b2208b2cf931afd60b8e0ef34dc9e51ef9631dd78802d8f8172"
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