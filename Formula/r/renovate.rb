class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-40.29.0.tgz"
  sha256 "036f4c75a9e42ed52f5d3e6d2587d5450285bae65d191ec7cdcf6e7e45124d7c"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75ded574510ecaeda2ab2751000bdf76ac78f9ca2b302740dedbd01b7cea7c17"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a91b35ef1b22c5b683c156f8a6b073f82a05a9fc71d6f953d9d9a7a979c15ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a06e202013b586ef3bb7c80eb6d90556ce6bbcfc86ce18629c4338ed5eca138f"
    sha256 cellar: :any_skip_relocation, sonoma:        "a7cf50aac42487930d2771d93e74d207a6ee37660295205a3462f548920fedbe"
    sha256 cellar: :any_skip_relocation, ventura:       "c2c736f51c4e0067da6a3bc26444b49dcd68b948ecee07cefcf14fd1c6baf822"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78b7d4101cc29652cd7b2487974b71b8e714d08700caa3f7392d148f6d9cf7dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6446b445aad56354f485c218338a674cb04aba4bbcc7fb9fd2026b912e1c8f3"
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