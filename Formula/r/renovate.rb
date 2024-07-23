require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.439.0.tgz"
  sha256 "6c800ba57c695fc13c0a0506108dea463de3413f9eadc0f485108e448beb0662"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a3fe0ce44f5fc03fc57cbfa4a954d112d18b40a353e90678716a8ba7e3ad4728"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7b394e0a62db6e849a1c6d9abdcbee49db88e684e56acb601d402a888fe150f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a05e819eee33f929dba82bf2374e0edbd6a337ad00f1071f4c8b4c0cd20859ce"
    sha256 cellar: :any_skip_relocation, sonoma:         "de097b495bd23beaaee42c4cf4613a039da8539231fd9c10218a33af75ed4c54"
    sha256 cellar: :any_skip_relocation, ventura:        "ec5e08a2ff472d692894ae7a32f1c9f93afea8601786649ecfbe1e3757b9001a"
    sha256 cellar: :any_skip_relocation, monterey:       "eccce73aa6afe800ada230a3edaf0ebd9fce5d0d5acb2d8b2b6b6931cf4f52c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b01f3aeba24d34ac654436579658ef16e7becbaccecc67202f8da56bf3bb22d7"
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