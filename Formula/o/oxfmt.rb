class Oxfmt < Formula
  desc "High-performance formatting tool for JavaScript and TypeScript"
  homepage "https://oxc.rs/"
  url "https://registry.npmjs.org/oxfmt/-/oxfmt-0.62.0.tgz"
  sha256 "d587ed382f26084bd6e001eeb07ee4043dce54a4829c924495c522689144d354"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e7c1e293938931151d97913771cfc995fe5d3b45617784723199140ea1c46e6a"
    sha256 cellar: :any,                 arm64_sequoia: "e7c1e293938931151d97913771cfc995fe5d3b45617784723199140ea1c46e6a"
    sha256 cellar: :any,                 arm64_sonoma:  "e7c1e293938931151d97913771cfc995fe5d3b45617784723199140ea1c46e6a"
    sha256 cellar: :any,                 sonoma:        "bbe4810a832c2deb847d9698ba4974ac6d4826b8b3dc1ba5ee9726a7444741df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "278816e1a732816cc9709b20eb41e2faf6ea899b87c0dc9bde1f9e351cd54160"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5911f34bb99ab7dbaf45d8eff9a212105d3a89447d23fde02e8d79955aa6001e"
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