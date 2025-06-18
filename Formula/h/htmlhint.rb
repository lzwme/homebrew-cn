class Htmlhint < Formula
  desc "Static code analysis tool you need for your HTML"
  homepage "https:github.comhtmlhintHTMLHint"
  url "https:registry.npmjs.orghtmlhint-htmlhint-1.6.1.tgz"
  sha256 "4932de4468ae95ed84a26c330fbddd35e1e8d7855f7bb7ee52f4dea2dabb86a2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3f5ebb82dd16fe33087e689cb0c3f2dd80b23a6f6d3c036680abe4d86bd09669"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}htmlhint --version")

    (testpath"invalid.html").write <<~EOS
      <!DOCTYPE html>
      <html>
      <head>
        <title>Test<title>
      <head>
      <body>
        <h1>Hello World<h2>
        <img src="test.png">
        <a href="#" target="_blank">Link<a>
      <body>
      <html>
    EOS

    output = shell_output("#{bin}htmlhint #{testpath}invalid.html", 1)
    assert_match "Tag must be paired", output
    assert_match "Scanned 1 files, found 2 errors in 1 files", output

    (testpath"valid.html").write <<~EOS
      <!DOCTYPE html>
      <html>
      <head>
        <title>Test<title>
      <head>
      <html>
    EOS

    output = shell_output("#{bin}htmlhint #{testpath}valid.html")
    assert_match "Scanned 1 files, no errors found", output
  end
end