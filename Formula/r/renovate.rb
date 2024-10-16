class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-38.124.0.tgz"
  sha256 "f2140c5efcbbfeff173c3cb205ca73a30db3d65c7b50ab6c9baa32864937d212"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2f0972b10cd4702f386cc0077230643076e7e4614bd16f8a4fe14cbe7d5f8d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c4345ec11e03ef17705bfa359d513918e06fae0876fc6b65bec83c958f61e70"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "60d79c52dabb3418fafd35e43410f9fb0bfd13ec5217136ffe679ee636c696e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b4f5e673a3844a14cddc55d8838bc2396571ffac564f05e0be20853db7adc17"
    sha256 cellar: :any_skip_relocation, ventura:       "a6fc32cfa537e7fd501e93c8d35ab87e91e230590e40603b42b64cd77f4e93eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a936d36fc0ab1120462e928cbe711bff5458bf06370c579fc484ffd77c2dfbec"
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