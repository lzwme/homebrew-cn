require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.183.0.tgz"
  sha256 "f30a6bc4ab1ea06e5ed263ce03eeeb729cf1430e0bc36d70d081dd3138524b7c"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and page the `Npm` strategy
  # checks is several MB in size and can time out before the request resolves.
  # This checks the "latest" release, which doesn't have the same issues.
  livecheck do
    url "https:registry.npmjs.orgrenovatelatest"
    regex(v?(\d+(?:\.\d+)+)i)
    strategy :json do |json, regex|
      json["version"]&.scan(regex) { |match| match[0] }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "03bfeafef11bb50943c2f7d1f757882c4a66b337b1746b8459846e8d61a69b07"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df9dd6ffcd12069530847742b0399b7de0406e19fb4abea42188e0cf03f4ec20"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff6e53037724a47983c29160c5d0a2c42c40ae2ddcab02c612ad6f9458fdc0ef"
    sha256 cellar: :any_skip_relocation, sonoma:         "8414432711a58365df6209b823e4075019c7de16f8df13b29839790f4170d230"
    sha256 cellar: :any_skip_relocation, ventura:        "a3856898159db7acfb42445fb50fdf01143d8432964492f162094bdb38a79bf6"
    sha256 cellar: :any_skip_relocation, monterey:       "5a22cf720d5f35e1e6b13049b937bb419c34a34073b1794ade20ad41c470ce7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "653a0a860a71c896485e4f53e1a5741bdc5aa430e4c89634f29fdeb92d956c88"
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