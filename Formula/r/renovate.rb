class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.122.0.tgz"
  sha256 "7ae16f1266876e4caa452723650dc8f8e26abc45d98809146190ffe951064857"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "986eb6a4accbfe29febe5ae31409b014e72df008659535ebd5e29376364f5365"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "308333520a9cb9ab54617e54f56623f0da52417d28d32f0569c0b14fe98b19f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f557e16569abc894fa4cc7a6e73f82600c38871d91343512f6e5e233395719e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "4dd2ebaac053a9ab758fee35c60c652bfdaba9ae0bacc775067a918fb2170b18"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23b882f651abaacce340223e9eb1a890ca7655b3cfdfce8053fe892bd23b02eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8829f3c86aa5eccccba78fab311a961170321fa43b1dfb54b5093c0fbb91c4a"
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