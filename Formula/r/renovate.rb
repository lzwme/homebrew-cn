require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.425.0.tgz"
  sha256 "3fc597e36832f80d0f4ad664e70434b8970a4a04ef19675bc25b421a6947119a"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1b71b9eec1c8f4d35d81dbde9b85ce42ceee6b387231e80bc568d3795fbde7f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "03c3da246583c8a9d8e57dcebe9d4403f436371437f13d2cf6eca39d30d6ebf2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a4e40c6df8b6362ce3e01f3971528d3576e6da7267c59c5715ea21c44c6d2a7"
    sha256 cellar: :any_skip_relocation, sonoma:         "dd1bb0066c4b2321fc09e0bab8b70d11198cb05ff985aa4fc8466499073602f1"
    sha256 cellar: :any_skip_relocation, ventura:        "4d2d91af2bb11b5fc415b5b5af1fb5da7d7e61cf01b5aac092215dd011309033"
    sha256 cellar: :any_skip_relocation, monterey:       "40e9437c8866297d260a556bb665f3574f2dfe475daea7c62f3a142ef76f5c16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6c132c88a476b60cbdb92dc19c4a3e3034a5de28d9a743ed57c7cdbadc46b50"
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