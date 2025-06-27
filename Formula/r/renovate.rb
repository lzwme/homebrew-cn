class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-41.12.0.tgz"
  sha256 "56803d1add422280e2ba2298de5d4e339819e662541a6d247acd948b5c9388e3"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "541836d258319f87e0b91e2c2dc6a5e5836170dd6ce68a33758f3a223bde5dbf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "479b652f12d29e0cfaf53292797ad5fd245a361aea93985d9e1797a77bc2dc9d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "484341539b1ca43f283214552d96b1b53b19f6c6989d40302322bc4da03ca33a"
    sha256 cellar: :any_skip_relocation, sonoma:        "153d594bf0f769146007364270f5e22d27285a77c45e4db1f85dc08bfbe523b4"
    sha256 cellar: :any_skip_relocation, ventura:       "b3e9d7a9d32372469176157a36a460c29fbf244562dab593cdef7e3967804af5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0952cd369aec9bf4bd1101b7e7362e39d35234f79458d0eecc04fd694813f601"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41e3a5469d24b4a0d51a5b4719d1de662def42231a5da98293309b849f8e3e87"
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