require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.303.0.tgz"
  sha256 "89b3cafa0c103402633629abfbf78da3fd268cf59ac32d25ac514a8fd01bdb19"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "88d2bb49ba5b3dc3adfee67a01d87b420d97a118f58d825a6862b4923f1456c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6c11de5bae4327231e1f9879c018759c11caaba7c1208bcb1f96155f09e88d71"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0612db5f4829e12ec6377863da372dc7ad6eeacec0ac37fffe81376cb8c073ca"
    sha256 cellar: :any_skip_relocation, sonoma:         "f4dcc9b66ca1c7fa50aa2d2770a49dd37c12c8ba4f1e5ddb6c6cb4ec9fdcf931"
    sha256 cellar: :any_skip_relocation, ventura:        "398d5da14c722a623162f3fb307e381842800d06aeb7efb17f488a0b62947360"
    sha256 cellar: :any_skip_relocation, monterey:       "2b5a3fc7b8960807c3d511b4d9c13e4fa810ef4762b695fd73cad3e003c6f742"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26c83a769b1a51aa3c4be74bec5b27e5ea7cd771d3d51bc7fe062be557159590"
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