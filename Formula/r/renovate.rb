class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-40.39.0.tgz"
  sha256 "9a054d59e6e67b0e54d49936fb60668cfb937121ad8f2cedded1e4f6effe96f3"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8da78c62be3fce9c99777db1a14c12bfaddff758ef9f48ea3eafd09893ae2ddd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93d525431c76e1917303dde8330b3659005e23181a73a2a5387d41ef4004e5ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "25c71424a220f1c9cc4c7aeec80057261852ce1c7a4c0c948fadaf8cde0fb0c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "16eeb19c33e8148b62c22097ef6d086983e6b748d1fb22bf7d8876e2d9953063"
    sha256 cellar: :any_skip_relocation, ventura:       "9db5dce0f4206ec01e0c733b9aee5a6d5d81ed9a89a64f1b4baf3dfb21eefbfb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0bd8063cff1e3525b6ff3d99d7db3a25834daa903721f40430beb04ce83fa59f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d5beed202ead3eb3c9a399dc9482fad7bbc4a0a1336654b19b94de9c7ca8b2e"
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