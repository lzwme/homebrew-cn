class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-41.11.0.tgz"
  sha256 "b85a93ec4c9a5590b3fd0769bec41fa94a8e866fe353259271de7ad90f8cea0a"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8f47966b3916f2d69e4b85a3be06deb4b9dccd88e341a98c17ebd30037fb0e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "975f84aba7d4d92de229c8c70f059a074769a8b76ca3b427d6410473856082de"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "13703d5bc6360f5b31c0cf523e77e7f13d4983f4f1ebf3e2bac0f08124c1470c"
    sha256 cellar: :any_skip_relocation, sonoma:        "49ca3042d7d01f85ddcaa5e3c6a2433f4f807b007f1ac138a010fe6d0df0e138"
    sha256 cellar: :any_skip_relocation, ventura:       "a583423301a909c712b3b77e1bf8e8418fd9daf0984b9fcfd5406da9d1fe9b75"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad3dbcaded62975b3b5f28e477ffb58f89b62864ca24859d979c11cef59d9e4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98fdb2995b2a28a53228667bf3303b1d8ee185c9b794678dbb5872d208b18f0b"
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