class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.160.0.tgz"
  sha256 "46a59cb2ad7c01dff910bac38294bc494366b5aac4b9e4fba8ec85a2297a20f4"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48354979bb3f2b432c229832eafd942bf3803e112219f19eae76e637e02fb200"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8c6c112ba082ec009062117f71aa04ecf7c0da23003d61f664c28aaf9026728"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c5f227c3baaaabf75c9da4f5a465f4ab17131d7500d649b66bae82625e7a1132"
    sha256 cellar: :any_skip_relocation, sonoma:        "88b111b91e2ba945ec41ab1105d46a9ea80cbde150a187965e4f037b363e2ae1"
    sha256 cellar: :any_skip_relocation, ventura:       "4d20445b42ada988c7dbfdc80c892756f4b5a70afc6177a9138ab2ca735a8d0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b9f409b974e6fddc64ff4fb1ea339aad0eafe85669f759d33a914e2f9ebe720"
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