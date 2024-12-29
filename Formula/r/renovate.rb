class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.84.0.tgz"
  sha256 "80eb9786ded9db72122e20788ee25ef6cb324c8bd8dae2f4150853636b2a6d9b"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8207782327155b96f3277dcde6e6bab3da4b18372170cbff1725bf41aeaccda"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4832620f768471f125d8849fdcf0bed8533323c70e9882fe976487600ab0e934"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f9aeab5dd2595941b3c388e63e63d3778f5f03fc7d4fdee2ac3cc17be3efcea5"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f673f04682bf0ac1ff5207e1f9e245ca0552f040de6018e262277e4158e28f4"
    sha256 cellar: :any_skip_relocation, ventura:       "9d1edcfef16cd5954a316888819c4b8c1e6492d457ea6e852f58d643127d3752"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d583b78c4cb702a5a9e609721984208a9c54d560cae0f4ee1c3e53791ab0c6f"
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