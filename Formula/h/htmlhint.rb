class Htmlhint < Formula
  desc "Static code analysis tool you need for your HTML"
  homepage "https:github.comhtmlhintHTMLHint"
  url "https:registry.npmjs.orghtmlhint-htmlhint-1.5.1.tgz"
  sha256 "8e9083850be1b62f712f847e19dfa89d8507b8487448b6ced1734b7f19190cba"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d53eed3573cc4f368689c7fdb36fefffd6317d2298b89d0cd31a5790e5b0ec79"
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