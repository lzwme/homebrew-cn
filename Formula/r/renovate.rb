class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.86.0.tgz"
  sha256 "fa6b1bba708120440a547cb59fb43158904493e10392007d888ac5f2f6050c6d"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and the page the `Npm`
  # strategy checks is several MB in size and can time out before the request
  # resolves. This checks the first page of tags on GitHub (to minimize data
  # transfer).
  livecheck do
    url "https:github.comrenovatebotrenovatetags"
    regex(%r{href=["']?[^"' >]*?tagv?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1c94a43138a200e867c14578b9bef2b1a54c0955d03f9134e532cb68a9d51ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ecd88d8da1b6ca4580831f06fb750c13a2ea478b1400820057577846af5f119e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ed08c7554b6a5e37175575473da8454293898f2880cc9103708854fb2fe52ff0"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ffcacb9be115dc3bdddd836940837c1f0cda775c2ffd6f3886f9a2a597fb975"
    sha256 cellar: :any_skip_relocation, ventura:       "20eb494b235ef8e0ff1270c80218efa9da34c484231bfba6d7cea34ad6080801"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2baf552b0688a8fadabcd5e9c4cd5313d688a0d6a386d94700278af36de6e7e9"
  end

  depends_on "node@22"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    system bin"renovate", "--platform=local", "--enabled=false"
  end
end