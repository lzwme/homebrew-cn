class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-38.133.0.tgz"
  sha256 "a366bec5160057c60d3098ee274543427607c28b832a4cb0e6daa17b5884b595"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8b1234a5b793ad7e51459de2101204738ee1a00734382fb5ec2d7f4b2ef6150"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9191482fe9f8c690bd87de3d3407026ffd55457ac762557cd6794aba290b632e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b284394fa11273c5794cc1902b9ba04b5ac4f0638d3a5475d5723ed83e97af4b"
    sha256 cellar: :any_skip_relocation, sonoma:        "fde714cd536918d233590322ccaba4b9a9014250b5e125a9b4d680e1ea55d4b8"
    sha256 cellar: :any_skip_relocation, ventura:       "fb05e8f70364f92e826404f68583488668c997de1cad874da5d6ba14d1fd41f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0f9306b02041e3a0d3a222db78ffd2a3d2d302254181df6813cc100ca9b487f"
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