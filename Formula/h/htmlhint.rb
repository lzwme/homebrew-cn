class Htmlhint < Formula
  desc "Static code analysis tool you need for your HTML"
  homepage "https://github.com/htmlhint/HTMLHint"
  url "https://registry.npmjs.org/htmlhint/-/htmlhint-1.7.0.tgz"
  sha256 "46f86542653b03005975cee344208b24ed7d24a6358b205b6cd397b6f9d2477e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ecfc96e9b07f4b01fef08e5a1c803cd388d09439faf510dba1cf4919dbdc2673"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
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