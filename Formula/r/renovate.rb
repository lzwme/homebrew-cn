class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-40.13.0.tgz"
  sha256 "eff2c5528c4cc6169784f999093574e9dc9b37a08c9cff35d2fc0debfd0a37f8"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d2e2157db31d8433b1f02bf2fe23bbfb215046a99a7e3f9e42c7ded8ac0d671"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32cb718c6a4e56ee15257f874ab551f115c9a55203a2340df76bac59c07749b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6e9bf219bb16481c8d65b2aed0fce664e0dd7e959501b4d66d2304a6e5633e44"
    sha256 cellar: :any_skip_relocation, sonoma:        "71eac7ae4110862cb7d1276515f8b7c9acb0b8cda7b50341215d7696a141a166"
    sha256 cellar: :any_skip_relocation, ventura:       "ed30b9b47dc3575d33ecd52baf35b66730126bd58df39219de025f5aa0c87829"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6706cd15ae65baf8cbfa4721bb1767cd884c59d1b2bbfa057590f1cfaf9a502b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36ba63a77ed75e9f90d1423ac6a0d2ec2af41ead2b6c71e71d64b45422335bd0"
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