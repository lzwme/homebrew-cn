class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-40.3.0.tgz"
  sha256 "8179af2ab9656e62c267ba2e70576bfc4afe9a202b9e2f4d605852ad85750532"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e20e7c9097ccbbcbd5dd474c52a4bbebbbf6703f6c7708bb7c935f1076b55242"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d7e228a6fe4f301360ab0e223cc74e3970518fb63ae3e78c3a37fcb090ca81f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7df7728cc320d4dbd2610dac37d1defe0dbc0d2ada3c4eb961578f9afde59874"
    sha256 cellar: :any_skip_relocation, sonoma:        "4af193bac01c7a0ee02caebd2760f7ce6409016816cdcfbeaa3854008325ebac"
    sha256 cellar: :any_skip_relocation, ventura:       "b2aec9399cb03d343e483fe8acb9116eb2fae6264bd495a74264003fc200ac80"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e5e758accf9af5ca7ae875e9834a2551119f4cf6cf3a68c4d26355bed98b1b22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1b8321bd1bdc44bb9c311634c4ee55c05163a76b48c4c642720a872f10f3a58"
  end

  depends_on "node@22"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    system bin"renovate", "--platform=local", "--enabled=false"
  end
end