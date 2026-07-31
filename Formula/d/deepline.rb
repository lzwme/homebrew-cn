class Deepline < Formula
  desc "CLI for Deepline data enrichment and durable plays"
  homepage "https://code.deepline.com"
  url "https://registry.npmjs.org/deepline/-/deepline-0.2.0.tgz"
  sha256 "da7ec33839f3efb3283e0dc971705526051f3065e63ff33ff57b7f31e2551ebf"
  license "MIT"

  livecheck do
    throttle 20
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fa068028db14c5c86037b6021993d6092ff94859dc53f9ad0481b8681e0510b4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa068028db14c5c86037b6021993d6092ff94859dc53f9ad0481b8681e0510b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa068028db14c5c86037b6021993d6092ff94859dc53f9ad0481b8681e0510b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "a39353c18d5f9d6ec327967413adac13dba066f4873b90fb37e39671ca4f2d0d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7974a554e2fe304ef1033eb3ccd93fb607c76ceac2b3b331df0cd2502b32be5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc8d336662f87107bddf59d4a9f8fff389aee59781f6001051ad7bca9b576cba"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match '"status": "not connected"',
      shell_output("#{bin}/deepline auth status --auth-scope folder")
  end
end