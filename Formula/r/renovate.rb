class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.182.0.tgz"
  sha256 "4455d0b6a3c37637822f7294136ec80cd94f777441ad7047c4d293798a5debd7"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f48522276356b4fa42e6be1bde6919243b9329cb6585541bfe7816042c2a6fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4887bc4e0e7b93b28fa245153e74cde1bcd9123a7a9de7198ef4274977cb12c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "53225a441fbb22fe987c9b3d37ce3e03e77e39dda3756a419490c2e3ec768f95"
    sha256 cellar: :any_skip_relocation, sonoma:        "93390bcbce8d675475ca9f4281b8e68b6d8ee5501c3bda9a2bbba66effdf636c"
    sha256 cellar: :any_skip_relocation, ventura:       "d91eeddbfb0ca43d41a4dbdbc9e16214b36d0c99b0a9691ee88c033504e0e360"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb5c31566257b55854ae403aa8945f6672eff48fcb0e13a36aee3f57a478c812"
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