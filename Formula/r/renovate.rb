class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-38.67.0.tgz"
  sha256 "a987efb60f735b6b8d53d52f87027ad28b2922fe6ede21f7eba2403e85b32cd6"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bb370aac48705c4e7dd5fe76d6eee27987dd3c9f01dd2e527b165ad6611828e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db4cd5d63554834407678d36fc2c7288074acf2c117d0c973e52252623301898"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3bece8bc9b8b11a709b324ba6ed67ce6603319ff4af2906d05ada52b22def0dd"
    sha256 cellar: :any_skip_relocation, sonoma:         "0983a7a67d922e4d87690da9c1df72d7f6ef4b8d01b65ba05eb4d8309cc2f8a1"
    sha256 cellar: :any_skip_relocation, ventura:        "82caa35fbb9ff4750cc3dfea18b41c727072b9c246c5d480328821b157b34637"
    sha256 cellar: :any_skip_relocation, monterey:       "6582ec3b0b2f57d3f31795f3effa881f45e18ccd876a93d27f8a942d2e5a111f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b73f3a5011494a058d66dfd1d93af935a5d7eeb84074424cd5239f84dc829862"
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