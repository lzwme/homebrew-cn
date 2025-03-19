class PhpCodeSniffer < Formula
  desc "Check coding standards in PHP, JavaScript and CSS"
  homepage "https:github.comPHPCSStandardsPHP_CodeSniffer"
  url "https:github.comPHPCSStandardsPHP_CodeSnifferreleasesdownload3.12.0phpcs.phar"
  sha256 "a7d659269a1963e729f29fe9e4ec46202be8f843ba20aaed6ca5cefa2d4396fc"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ec9dcf0e0d33dc2685251819662b8f6eeef6929af8f0013bca926bc559bcec6a"
  end

  depends_on "php"

  resource "phpcbf.phar" do
    url "https:github.comPHPCSStandardsPHP_CodeSnifferreleasesdownload3.12.0phpcbf.phar"
    sha256 "7ee8682c53b3ded51e528f9cec20fb56c6720636e5407833f92047f9a690a761"

    livecheck do
      formula :parent
    end
  end

  def install
    odie "phpcbf.phar resource needs to be updated" if version != resource("phpcbf.phar").version

    bin.install "phpcs.phar" => "phpcs"
    resource("phpcbf.phar").stage { bin.install "phpcbf.phar" => "phpcbf" }
  end

  test do
    (testpath"test.php").write <<~PHP
      <?php
      **
      * PHP version 5
      *
      * @category  Homebrew
      * @package   Homebrew_Test
      * @author    Homebrew <do.not@email.me>
      * @license   BSD Licence
      * @link      https:brew.sh
      *
    PHP

    assert_match "FOUND 13 ERRORS", shell_output("#{bin}phpcs --runtime-set ignore_errors_on_exit true test.php")
    assert_match "13 ERRORS WERE FIXED", shell_output("#{bin}phpcbf test.php", 1)
    system bin"phpcs", "test.php"
  end
end