class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.92.0.tgz"
  sha256 "cd5f50ad8714bf67940f4801c04bcce8d8407dae68fcbfbf82241be76497f310"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and the page the `Npm`
  # strategy checks is several MB in size and can time out before the request
  # resolves. This checks the first page of tags on GitHub (to minimize data
  # transfer).
  livecheck do
    url "https://github.com/renovatebot/renovate/tags"
    regex(%r{href=["']?[^"' >]*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22289eb83345e085d38027cd989c8bec12897785e0632c7739e20bb0d48c3741"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0de6673b979c2c329956873beb3fb90dd424092ff4c93fa4d393da87ed3d7ef7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b867c58cea71ab084979d02d7f79412626a7065150b99f30d247538073c0cdfc"
    sha256 cellar: :any_skip_relocation, sonoma:        "08af5316fe7c0c9d875a9a1e670407a3633082caa42700c5adad4414dddd8515"
    sha256 cellar: :any_skip_relocation, ventura:       "cad2a863773b28257659283110dcd345e5d47ef7ed93ab61b4cfe6a49a124d58"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2a103b84ce46b4240a2e8b6590771adc2c849500c301c009e337aa7b3e9450b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c05813d4159340c046f8c0472f56717cfdfd7e988ca3ee84cafa64d1dddaf330"
  end

  depends_on "node@22"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"renovate", "--platform=local", "--enabled=false"
  end
end