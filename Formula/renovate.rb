require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-36.8.10.tgz"
  sha256 "a894d8b394cd89be2e6bb40870f3256140b573161d76360a27a408eb3cc853a7"
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
    sha256                               arm64_ventura:  "9514e31ec76d66d248b405b435b78c2600ffda0a6ff0311313e7c8b4d1dbd10b"
    sha256                               arm64_monterey: "eebc8873ce9ec9f012795d958a47f84ff2be58465307d5479ff4c74643de8435"
    sha256                               arm64_big_sur:  "47b32c4e3aa8dbf571238cb770afa9893dfb3c6b9bc2b534ace2e5c302b8b33f"
    sha256 cellar: :any_skip_relocation, ventura:        "bc0069965635de2744cec6fb1d989183b8fab74391768599f05d515647b1056e"
    sha256 cellar: :any_skip_relocation, monterey:       "b02ac3db085298be86183206955e01f4dd22e9113f70c7e8366af6b631f78853"
    sha256 cellar: :any_skip_relocation, big_sur:        "800c1a1629a8bf04aa94634bbdf1a16a75e24026824bd355e2776b88e83c04fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9780d14e05acda87f2b11aa7bea9d374d3b2c31372e7fcab4657642bfbde132"
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