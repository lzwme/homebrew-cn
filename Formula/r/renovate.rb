class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-38.18.10.tgz"
  sha256 "3f420b1db68123aa21c828e0d25c329bd8ea00e6e866736ef5a910fb4502cd19"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "11072742cf5387386944eca6defb4c7ca2b504f3095ce6639c8e0b14881d2051"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5edb7508788b05176d578b9029896677ef8102b6b44982ff4a30cda137d036d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb9b749b2f981afbb16501e95d8b46b520d14c89f7bd7f75d0cdf851e9978858"
    sha256 cellar: :any_skip_relocation, sonoma:         "6c1c123807a572d77572a9070d557262958f93ec822cc99779470387bc78a3c2"
    sha256 cellar: :any_skip_relocation, ventura:        "e662006927b56a7f643ad27223608ad9aef7d7d4edb205d0fa4459ea703e4f7a"
    sha256 cellar: :any_skip_relocation, monterey:       "b9f24f248ce651d626a77de8d836b8b1b2fc3a8f4b4c209da19663c523dfb7f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5aaa3337b724a142e5954997edc6603cf5edf52e0c12550579ce166f8a1b55b"
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