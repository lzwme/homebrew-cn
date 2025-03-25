class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.213.0.tgz"
  sha256 "e638347ff0bbd2990e5007e3a4a6352dc7f714e2f054812e25f40cab76a53940"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd7648f8691b18673ae8f814be793384566c584d41e33af7fcc8dc6b15433af7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4b3049a585bb4ce1d1f4c3fda105de010fd980ba5bc532a4b5e033632eb13ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a5096569cbd2c6f2c82e227f5d7d014fe0a0a027297a45655bac9b0d93b0562c"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab0b6a2773550b8f4be332ab44f7621109006e23aaa7871d4380fc1caeecceec"
    sha256 cellar: :any_skip_relocation, ventura:       "8178f573224ddfadcbe7864ba448b21b8a836b36661c4867c01360aade1d0d30"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad7c9bc77d7f0f9d92f4adf4cb2b19d2425bb3e56c8bc938e8a6a60fffcc5b1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a36a2f9914f8ecc7883c8f884ce16ebb7c8a0a10ceed3634f3982154ab8f7f5"
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