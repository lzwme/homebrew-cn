class Oxfmt < Formula
  desc "High-performance formatting tool for JavaScript and TypeScript"
  homepage "https://oxc.rs/"
  url "https://registry.npmjs.org/oxfmt/-/oxfmt-0.55.0.tgz"
  sha256 "6cfef0bbf118148b9d09d8206673547c374c91717ce0566d88e2d3845532b66c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "98189e9aa484c787b50d00a1a1d6ca10461955f3302dd0a88310f6208b16dbe0"
    sha256 cellar: :any,                 arm64_sequoia: "f2418952f87589f9ac8c1df6a210798f04d2e05a629b04d97b77534f07f7c3f3"
    sha256 cellar: :any,                 arm64_sonoma:  "f2418952f87589f9ac8c1df6a210798f04d2e05a629b04d97b77534f07f7c3f3"
    sha256 cellar: :any,                 sonoma:        "a6838bf37661b748ef0bcbbbe597c24dea6427166d064086389f717d5414d3fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d99e7c1cac1afa4829496a87b8a16ec4b1867caecbee75a074556287ad366a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0600db4809d394d252a143176261d8216ca1f1a73c0a72904cba5523e8988bfa"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"test.js").write("const arr = [1,2];")
    system bin/"oxfmt", "test.js"
    assert_equal "const arr = [1, 2];\n", (testpath/"test.js").read
  end
end