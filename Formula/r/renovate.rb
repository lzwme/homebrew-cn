class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-38.73.0.tgz"
  sha256 "2f70a2f03ea958dbf2f0e07e69afeb92a93949512983cffc8da56415c0544980"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "959b7d461af82c45df3cfefc68c59ae45f41eaf0022df1e7d253e799f7d4b079"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7237b86af354c66ab86d1423bb2e636302edcf1c6b74e7aca76cb9026ea37614"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6000a3fb92d1036a73cfd9366924b3ac5ce4d7bed0f2404b7de040f1ef8618ba"
    sha256 cellar: :any_skip_relocation, sonoma:         "b61555a20c303f3d915f4dfbfb04d33184ab992a59bb4e70663ecb8d1c189e8f"
    sha256 cellar: :any_skip_relocation, ventura:        "f18b21ef15b80eb020302e34a5d896c7b4941c505841db693fd4b3a62687e4eb"
    sha256 cellar: :any_skip_relocation, monterey:       "b5036b0e784f301357e705709daffcebe3647b884c2596fa801c08f5c7b17680"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c091c4ca74542ac480da18e620846cfdcf2b872aa4aceab74e43c92b2933635"
  end

  depends_on "node@20"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    system bin"renovate", "--platform=local", "--enabled=false"
  end
end