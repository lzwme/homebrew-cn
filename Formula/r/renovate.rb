class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.165.0.tgz"
  sha256 "31c2a4495f04c44010bd2e985a802c9350931c4df161543de6648d1e26062609"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "32ad77adacc9c6319cf2c8bb35d8aa9bae1a3cff38542a6d1360add45dc322c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1fea264a012c39197ccfef9fcc5da31ed62f0b0734c468b65bfc821d3e06b989"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dafaea14912fe66556510555518a1cb91c677bbb198a168732414cccbc3f6a84"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a7a3fd6e0bbde0e394e4339843d7c580c9cc3a0e09ef05c2fbc5e6eed06481d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f82cb7e541d6468cc6ba9ac15a8ba7f14bd77721d7c671234e56faf41abea97d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ace5afb995db58751e6fddaaf47f9fbafdb9fe76e575a66ce03efd4cef666b8"
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