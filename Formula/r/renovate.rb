require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-36.94.0.tgz"
  sha256 "298f021ef0c529dd958a1e3c21329eaf1eef7654222d157522f690e7517a66f4"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5526164f6bcb6eaa3651f95c28f45366e26eb82d4bb946ba3a0fb60c338575e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d240d9ddfd4b13473a44c5dffcaa79af9b4c23a88aab68b2683ca7ea0133ac4c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "741e40fcd2d6bc5dbbc90efcf5d32728250d05e94388e1ddc1c7e4a600d277b0"
    sha256 cellar: :any_skip_relocation, ventura:        "22e33899d2cb9601089a1355832e62cb7d79db1811cdb098781bc0398e4b66ea"
    sha256 cellar: :any_skip_relocation, monterey:       "0e47d8837727c36521435d4b79eb2862308c7078caad583517bddd6743a0accc"
    sha256 cellar: :any_skip_relocation, big_sur:        "b9f02b4679e5f197107c1baaa6b84debdaa66b341e60590fa676577187b3cab6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94de841ed1dc1046fcd7ad625fb880a53ccf537e41086c2db6dc41755dc8f2be"
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