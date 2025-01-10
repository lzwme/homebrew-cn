class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.99.0.tgz"
  sha256 "10aa199d2b14bde7474de07105207041b4ee722b3c8e93148c4e3ebbfe3b1f30"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b0777d77c8a5202826b9c66837fd4ec534585968d769e7f78e8df34cd2895f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c8c7b5eb2be62d4673dd77013e31a915d0a45531a218df6127a3c61f771a1d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2a7c1b753916166ea1d753dda3cfc3f736a022984ff74af1b2dcb02c3e2cb3a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "84a12e942b82c01830fc77c105b89b7b0ca9f3d952d92e68a0c619abc8e662a3"
    sha256 cellar: :any_skip_relocation, ventura:       "cc535c63f9a50108c22fb12e51c3620885e3317553c554e7d7435d2a95dd01be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "950b631ca0d577a6a5c623a899c835da88b98f02970279eabc296bda0b12b0f4"
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