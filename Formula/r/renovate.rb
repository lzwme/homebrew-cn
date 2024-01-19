require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.140.0.tgz"
  sha256 "14dda4c83469794ffbb288af566d7d7d137545fcf515758f399102ac1d35794a"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and page the `Npm` strategy
  # checks is several MB in size and can time out before the request resolves.
  # This checks the "latest" release, which doesn't have the same issues.
  livecheck do
    url "https:registry.npmjs.orgrenovatelatest"
    regex(v?(\d+(?:\.\d+)+)i)
    strategy :json do |json, regex|
      json["version"]&.scan(regex) { |match| match[0] }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aa1c7410d1c30772adf68df3cc3c0d01b3690c052b5a292d7c91dd37aae96f28"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "47209caa79cba1e79213c405361a6001e3221b4cfec1a775cc2e06eed2ede02b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4209d5fcc1d1cfa5bd89cfd50362d248dcf4d830bc52f630e458c22a9601ddc2"
    sha256 cellar: :any_skip_relocation, sonoma:         "7e873f794737d452aac5920bd859334fe11219a6af87ff6998ae7e59e0dd33be"
    sha256 cellar: :any_skip_relocation, ventura:        "987746b7906ed2219eb9d3561abe57cec032c9164b2cad9317b48d44cc9a0d4e"
    sha256 cellar: :any_skip_relocation, monterey:       "1375be896987f573bacb6bc39b47b00d8a1ba0cd0a53d5091eb6ab22b461255e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f54b05068f7e4d2fc46376b7c524bc63d5510cf70a0628aade0ee766e3110bb"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}renovate 2>&1", 1)
  end
end