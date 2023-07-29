require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-36.25.0.tgz"
  sha256 "9f07573a16d0916394a6d4ef6bc7a525701e67412abd5905da2ca586c9c473af"
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
    sha256                               arm64_ventura:  "ab47c2518348459732726d829b6feade078f919b4052bec841145f90b67cd476"
    sha256                               arm64_monterey: "940893c2a260d3886f8c8271d5b736ee5b4a589fcf718e6a872ef4b1374b9ac1"
    sha256                               arm64_big_sur:  "524310f862388c3836d5749ccf5837c3dfbefdbc0d0d757a093408d41169beaa"
    sha256 cellar: :any_skip_relocation, ventura:        "2e884ad516651dec427a7a5cab1ee9cf31eda20a5d5dcf3d4c7e5d6bbb158abe"
    sha256 cellar: :any_skip_relocation, monterey:       "efe212e02123fb6dff8d21704b8a5addd8f9808358fc804f88278cd822fbc38c"
    sha256 cellar: :any_skip_relocation, big_sur:        "e9f0eb366fa0e8dc41532359df4d69353f2c7d75ff1a1d9691dfc80f13988bdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b6587f4599e5bd2450b7fc64304c13673a76dea616eae787d70e5e615e13f24"
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