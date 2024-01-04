require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.118.0.tgz"
  sha256 "58b5ca9e1d51a889332f25edac05a06bc5ade28ecf3327155b996a21e38d47e5"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3139a28d87a017c95d7b233e6efdac5f1f93a4575d5fcb16b29e844f65e08439"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "de33d9a6d6e6dfd8ce46febe84a2abdbea6f5f6fd9658a8d0778206138312b01"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b6b6acda628a4928b07c681544378b2f9c73861fa888de9947bec0852e4a5487"
    sha256 cellar: :any_skip_relocation, sonoma:         "d49ee2c7431669cc0e32a3fb4888530fb30806f08d9dd5b658329fd304dc0467"
    sha256 cellar: :any_skip_relocation, ventura:        "ae5aa4a379533426b341a0265266e1477d61bd8ec68285874b9a82195708eaa7"
    sha256 cellar: :any_skip_relocation, monterey:       "9cd59ed0e4f7ced4c2133958fd9e06412faffdda0d78a32e2eeeb9185a11184b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "520f784f4b71cf66445338f458ea62f594fafc92e66611bbaca48c1e0573bd08"
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