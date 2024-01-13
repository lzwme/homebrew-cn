require "languagenode"

class WikibaseCli < Formula
  desc "Command-line interface to Wikibase"
  homepage "https:github.commaxlathwikibase-cli#readme"
  url "https:registry.npmjs.orgwikibase-cli-wikibase-cli-17.0.7.tgz"
  sha256 "6d0b9ae677e8c427d9f7d1fe214365bf818d24375b1ed1e2cab8375287184730"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fd65808154bda6b2577adb511128de608f89dd25b7b301946fb7e304d6e37b51"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd65808154bda6b2577adb511128de608f89dd25b7b301946fb7e304d6e37b51"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd65808154bda6b2577adb511128de608f89dd25b7b301946fb7e304d6e37b51"
    sha256 cellar: :any_skip_relocation, sonoma:         "d5614cc00e911410b9d4dce7b6bee68f4855c714f3fcaa1c801cc9223f1899cc"
    sha256 cellar: :any_skip_relocation, ventura:        "d5614cc00e911410b9d4dce7b6bee68f4855c714f3fcaa1c801cc9223f1899cc"
    sha256 cellar: :any_skip_relocation, monterey:       "d5614cc00e911410b9d4dce7b6bee68f4855c714f3fcaa1c801cc9223f1899cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd65808154bda6b2577adb511128de608f89dd25b7b301946fb7e304d6e37b51"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    assert_equal "human", shell_output("#{bin}wd label Q5 --lang en").strip
  end
end