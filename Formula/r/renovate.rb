require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.427.0.tgz"
  sha256 "9216ab19e18f6640915e66e89d69a6556217b23810e88922016b3be552733541"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2be7c5b39e22960d95d3c9a7641191f8eceb000344ac011c116654ae13a5a3ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7dd8be090b053ca949ff6721202d530c17ffd4babeddd7071397b0a67c884153"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb3a5e642b636edb00552d0f789b670bafc78b92c7ee7e1f2b72439c1dab7f8b"
    sha256 cellar: :any_skip_relocation, sonoma:         "6d1570f38ac451b677058b29905d73f0ab05da4a7371d270a617e26cebdd17d9"
    sha256 cellar: :any_skip_relocation, ventura:        "df800f9eed1d76353ebb3dab9a29acbe3f6ee2f0d504aff4ec55ba7879ed384c"
    sha256 cellar: :any_skip_relocation, monterey:       "878238d27e2c7eacbdd839ce219b6912dd47cb412ea0e95ee7a3167cf595e762"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4bf005d3afd71d1760ce1bff9a3135413fdda6d0f13735b67d0c0cfa28153800"
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