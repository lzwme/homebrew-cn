require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-36.68.0.tgz"
  sha256 "5b8f40d65a22d9c3ec1b692f167e72f68a24c7d227431ca143b2a7d9969cacf1"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "de8fc368e92561122093c2b76062f870b3a6802aacf020b3a2fd045e004ae821"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6fa636dbe4e97acbdb9b6172691436d1d707ee9f3c856e7cd1182029dfd01c9b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e24dea585004691d2659a3cd6c30d8f9e387fa5b7a0cdef64aa2a0b182fed912"
    sha256 cellar: :any_skip_relocation, ventura:        "649480fb5718d5b4245a0e6431e3d5f72bc0d70127b16ad2dac6d75ef11a7eec"
    sha256 cellar: :any_skip_relocation, monterey:       "f4a2389230b15459a62d595072b7bcbed5ea148488b9db8007a97a9569540a9d"
    sha256 cellar: :any_skip_relocation, big_sur:        "5830759f8279711835bc491229851e84c99cbe8d7ceb1153b97568d8135b4e38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b86733b0af3f3675e9498ff5ac463b2881591e89093241ff4f0b169d598a443b"
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