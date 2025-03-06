class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.188.0.tgz"
  sha256 "21fd29407edcb96febe1ffc5d9fb5ae1b693c7742db0dbfefec5f6b5860b5ba3"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab18960231d33541a0b00dce228c1b9bf822c628262942cb36d6b58f9f414bdd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d89a1114ca69688857a3a5a43e3c5c992748b44295b0ad58ff9db9209421dbf6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "addb4a82e246f7d5f421d7b04f2089c6fda6f1ec2d001156e2ed9ab0dc6070bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "bad0112737e22427ad6ecfab2bcf06135571c4f69e00e062837aca80b7d8d55d"
    sha256 cellar: :any_skip_relocation, ventura:       "d49caf2a8707a10ced84b062935715711e811ecef84587d7d567715367804e8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7297fe9963d478cb9b160792feed1abaf1ca9305520cec229b8ad425c96f2505"
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