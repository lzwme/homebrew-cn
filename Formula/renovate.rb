require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-36.10.0.tgz"
  sha256 "34401f5437b4b5095a38e0dd2b35ed2ad57105c7115cbc25061df23d16138a8c"
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
    sha256                               arm64_ventura:  "78142811b8fcf5808d7c093026580e9b362619c430923dd93f7739d69ae9a103"
    sha256                               arm64_monterey: "304a2d84b2c87b2da6a2c1ce8b44a52767544a086b7ddf0f88f219a744fabeb5"
    sha256                               arm64_big_sur:  "05dbcfb31368bd28d56af672ccfa8a66099fd2c1b6b28baf68cdfd1a63f91449"
    sha256 cellar: :any_skip_relocation, ventura:        "e9a595cd9e302a882f757ff20e2555ffb486b24abfb3ad90f7f12834f2380d30"
    sha256 cellar: :any_skip_relocation, monterey:       "9343ceccd795b6f2f83d59ae2cb47bcb55b9d7ebd5311d164ab32d77683a0a8c"
    sha256 cellar: :any_skip_relocation, big_sur:        "7dc5311493ffeb00c192260f3c2b64f77159fe69c811648f4039311e529b1380"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "411e2e3e55717b618d6bdfe6706bfd99ba4ce1170584a4dc84d42441a4edae82"
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