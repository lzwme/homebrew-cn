class Htmlhint < Formula
  desc "Static code analysis tool you need for your HTML"
  homepage "https://github.com/htmlhint/HTMLHint"
  url "https://registry.npmjs.org/htmlhint/-/htmlhint-1.8.1.tgz"
  sha256 "8d1c0b0cf428cc5f4d6bbc5a03a888c0679005bc085f31169c64bc1e121ad43d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a6e4d41b358313cbbf05de61301e1f78b918af5500c9b84243f7d58e69c2d1a0"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/htmlhint --version")

    (testpath/"invalid.html").write <<~EOS
      <!DOCTYPE html>
      <html>
      <head>
        <title>Test</title>
      </head>
      <body>
        <h1>Hello World</h2>
        <img src="test.png">
        <a href="#" target="_blank">Link</a>
      </body>
      </html>
    EOS

    output = shell_output("#{bin}/htmlhint #{testpath}/invalid.html", 1)
    assert_match "Tag must be paired", output
    assert_match "Scanned 1 files, found 2 errors in 1 files", output

    (testpath/"valid.html").write <<~EOS
      <!DOCTYPE html>
      <html>
      <head>
        <title>Test</title>
      </head>
      </html>
    EOS

    output = shell_output("#{bin}/htmlhint #{testpath}/valid.html")
    assert_match "Scanned 1 files, no errors found", output
  end
end