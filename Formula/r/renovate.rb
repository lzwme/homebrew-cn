require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-36.89.0.tgz"
  sha256 "1ce620d136a26fd79048033b719ccc0d2edaf6a90939cabdc92e41ce23c05705"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and page the `Npm` strategy
  # checks is several MB in size and can time out before the request resolves.
  # This checks the "latest" release, which doesn't have the same issues.
  livecheck do
    url "https://registry.npmjs.org/renovate/latest"
    regex(/v?(\d+(?:\.\d+)+)/i)
    strategy :json do |json, regex|
      json["version"]&.scan(regex) { |match| match[0] }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c600db0a64acff330a2806125a2461d2466d9cadc8f510549382a8cb472da5d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff1e6993b6fee0fd6a6e474c4e185bf757ddccda066ae21f82b5520d4630a62e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "08e69b95439245cf66f3cab1adebc65892a35803d77917a0cfab50a5b194e8c8"
    sha256 cellar: :any_skip_relocation, ventura:        "85ea56c3706fa5d6815ff765d2a4fe170660d86319a3badaeb85cc4093110012"
    sha256 cellar: :any_skip_relocation, monterey:       "3e1c6e1c21c7108d79accb5927ff5403486af4bab883a407cc1e065bfc414eba"
    sha256 cellar: :any_skip_relocation, big_sur:        "233d9a68a9d4bbd27f9bb1a2614586488678725c5c096890b0caea96a8700ab1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a0d54d588f7b88d054ef14c2b0db890da0792ad3fcca35c56462911be4189a0"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}/renovate 2>&1", 1)
  end
end