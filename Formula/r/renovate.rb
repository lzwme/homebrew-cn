class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-38.51.0.tgz"
  sha256 "c7b58268a17ee22c8d9af2598bf902be068c33a89189b5d00681f74a9c5d2aeb"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d6a9edb03171b107218fa405ef5c5cd27bafc33a0f111485947bb4daeb732b10"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4876a3234c08627ffade2e89599e6c3af3843956f874c522c3912310150af452"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "14735ddc36f64d03d5de5de9f3e95c3e95d4c80517aeb0a5c14905603bff1e3c"
    sha256 cellar: :any_skip_relocation, sonoma:         "f644e6073b6e78fc6230c383b6fe8bdae15c11ee61ca322b7ab7ed8ec63df41c"
    sha256 cellar: :any_skip_relocation, ventura:        "2a8a7ca26edb2a4643780ced7a58366e9f458718ec7b4a278f67b9caf7497010"
    sha256 cellar: :any_skip_relocation, monterey:       "c70c010b051275a1d4c1469ae0ba13d6b5713c4bd70c74f1546cf4bdbeab631b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43f27c04d46a6a5e0c04ee5676d6865b4f6c6552625dc88d80fa8550eb542a45"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}renovate 2>&1", 1)
  end
end