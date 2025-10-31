class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://registry.npmjs.org/oxlint/-/oxlint-1.25.0.tgz"
  sha256 "408f0a0aa25ba88e1a16892bdf4b0a2db4151e77e6113969cdab011395d6042c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c181e60dd26a74b94d2dbbd86dd817698704b8f3c7447f9859806645439a6347"
    sha256 cellar: :any,                 arm64_sequoia: "77ac40b1baa62b1fb273f7125a20b1143ecee08e96485bc354651664cfde2323"
    sha256 cellar: :any,                 arm64_sonoma:  "77ac40b1baa62b1fb273f7125a20b1143ecee08e96485bc354651664cfde2323"
    sha256 cellar: :any,                 sonoma:        "84f2dbb7b53df39273e43c8f3c187beee2cbe7c83bd2967871cab7215ffb5469"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "283b71953906249f5447b56162a0d99b414a2f8c44f06e00b41e17655a7e5098"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0873be8ba450e03d9e0c23df1ae72e8f9f15259b50e56056ea0f5cf1c3f291c9"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.js").write "const x = 1;"
    output = shell_output("#{bin}/oxlint test.js 2>&1")
    assert_match "eslint(no-unused-vars): Variable 'x' is declared but never used", output

    assert_match version.to_s, shell_output("#{bin}/oxlint --version")
  end
end