class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-40.26.0.tgz"
  sha256 "30d216b697ff22c1a470895fcddefb8f5d6b7baf22daef1005efbc181f2dc05e"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fbc8022f4a0b49a5702afc424f17291bad8f6cac77270490faf6f216e3431db7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ed2c558e98526d088ddc3b251043b2de1bb50af5b5683befeb8f41a9da941a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "24e659f7b9f7b4a7e3bc9ff53972ccfb03c51178c5fe7d41ebb409ceebaa01d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "22dd8519728cdafd95ceb40bcdf3cdb224047afde7f529af2d0a68112cfdd690"
    sha256 cellar: :any_skip_relocation, ventura:       "ec2341f9bb7f1eafecb33afbe3f1783b446bda0b120a9bfe8ab66e0fa482117f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc969d3a4fbe6079b074494248d6c0915c5699e31d5e29a794c907d55f8b8c02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37270f866b01beca223ec4e309b56c2d0e2c193e64fdbcdb7ec8994ee30c846a"
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