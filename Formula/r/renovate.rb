class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.164.0.tgz"
  sha256 "7ebad615ea107806cce86786fbaeaccdc953e47a60fa129d07d35909ce3926f3"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bae2472cb922178ae6202b891199c3af03d875790a3d91c2eed623946c8f7a98"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d11f37c38fd4c99a1f3d5aa88db0b6f7b5d26e9029c17dc57b1699269434cb1a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8347eb82420dd99c4155371d24d2b5766f0301c079ea0f639c0dff94edf78152"
    sha256 cellar: :any_skip_relocation, sonoma:        "7bb37b62468854b9eb65d9afb15ae978ef0362dfc82c2ced30cc674c969d5bcb"
    sha256 cellar: :any_skip_relocation, ventura:       "934a42874bfe7bd507c16e23425cf34a54b94d43b1ac9f26d235473f6cd417b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11cc32ffc53cea8e3b3bee7ab3cd92647b3715a3432b4661872d95c58c820b4c"
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