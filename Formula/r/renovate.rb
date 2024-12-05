class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.49.0.tgz"
  sha256 "88a5464616774e764455796a4181601a5fb86c4522a755f641fd8822a6b6ff66"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a00c5b7813618e3e7e3a50a2d8b562e426abdedf5caaf9f358bc0fe13ed188b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d143e2e94dc33afb7564c4ccfb0114abbc2f3c9826c5cf8c10cad1939f887cd7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c87acf505d5bf366935d875f14bc9937a3e458ebca96dbfb7ae893b92c2a2437"
    sha256 cellar: :any_skip_relocation, sonoma:        "7501fd1664dbf8082fcb98ac7093181179ab93a49c51b9f5dde80b3a3bcc3230"
    sha256 cellar: :any_skip_relocation, ventura:       "91ddb8e1f17349ac581c6cc0424f6bae0bf5c53d7bb0df23c05fed23064f4bff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb20c7a0d3703d09f249faaab65f61382389a7383cc9060997b722cb3c2cc0fb"
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