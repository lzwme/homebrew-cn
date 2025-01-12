class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.105.0.tgz"
  sha256 "46a65cef77dec51527e59048aeb03294cf1a216c9666bc88835fab7ae191784d"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e93d1d2b338663dce841d5d5d60de8c4ada329d1e6019945bfefbd0dd9d03aa4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d76e6d7ef8a9cb8a6a363d38a2187f1103a835cfa84282e4959f39b86052b981"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a95cce3476916634f6e2656dc936fd9c532eaad3994682772ad4985a65a6c788"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f250f6f09f57911155cb87b43692e7ef4ee44b9a796afd4a6b89c734f5c2770"
    sha256 cellar: :any_skip_relocation, ventura:       "6cadeb6c9a034bfea3bdda22eac9c32ee1082a17712b38dec32f0446aca39baf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a8039d4cd9ae6e02bcf0d18a1b5891619033f7605c75693d569c54d1ac8947f"
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