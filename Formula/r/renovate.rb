require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.418.0.tgz"
  sha256 "4b7d6870aae77394be79b507ea3bc82e8cf27c28e1a520b70cd8d66706ee0db0"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d09daf644ff8758177111fc865ef776a5de7f22a1314a7c71285c36347a54cf6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c4b79250d33a9af3990a894f550907d58157e4207eff8f160a80598280d97e1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "400ea1ff6af6c75ae1a50aa19fb5bb945d7d19794591022d742e00e471f207cf"
    sha256 cellar: :any_skip_relocation, sonoma:         "e1a8c49adf93d406e6c18d01fac516e8974deb05480c8f1c299ca1f85d12f164"
    sha256 cellar: :any_skip_relocation, ventura:        "009ed65114f4ec0665b043c75990075dbe8e6dec86c579b17c7934b283df4fb7"
    sha256 cellar: :any_skip_relocation, monterey:       "659d8ef242c3a767eeda2bc0944dc10b067a2bc3d6958e6b8a6c39ee65ea6363"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25a0f34ecd31982fa73b64b9a2686a8ab3926a3d03b0133a8c135fa463d0eedb"
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