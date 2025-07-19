class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.38.0.tgz"
  sha256 "571cdb633ad23482cf717a0283457222c35a57af339bf571a1876a98cd679f04"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a70eb1eedc0fc5d16bfe186d2ea0c7fbc81555a4d4165491783ac982ac8e7100"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db3a3cfcdee1a87086ce345c6d87c4e09c5265d92255596e23505423cec5531e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f12a15112adb279f0c58c14db61820de97224a84a30a7aa5da265595863ad68a"
    sha256 cellar: :any_skip_relocation, sonoma:        "225f51faf8bd42fb308dc5e1c540fcd1269c9364d17630d6fb7b1d42cd60bf73"
    sha256 cellar: :any_skip_relocation, ventura:       "a13990c791c0cf46f3a85f1cabbe3d77a51d84db11fb6e458e3faecfd79ea525"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ebf79e42bb66b2f5df8db078d94c7f1218ce037f280f3ddbecd5cc4a29bfba2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf47ee98be3e4cb0603fbddab644e27be9f932c33f4687d0cd3bc47218f7bb7a"
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