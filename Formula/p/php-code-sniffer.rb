class PhpCodeSniffer < Formula
  desc "Check coding standards in PHP, JavaScript and CSS"
  homepage "https://github.com/PHPCSStandards/PHP_CodeSniffer"
  url "https://ghfast.top/https://github.com/PHPCSStandards/PHP_CodeSniffer/releases/download/3.13.4/phpcs.phar"
  sha256 "ec78c8804e4a872979880331bcac8f81a7d485cb08531468af76ae67508b5cd1"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "66808a9214e9f979f45ceeccdf6cc7070f21c8b4f88df47c8dfcfb4f38464d0c"
  end

  depends_on "php"

  resource "phpcbf.phar" do
    url "https://ghfast.top/https://github.com/PHPCSStandards/PHP_CodeSniffer/releases/download/3.13.4/phpcbf.phar"
    sha256 "24b02f927d2319c7eeebc79741a1fe0b54993c0a0833223064c5b87b79299b42"

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
    (testpath/"test.php").write <<~PHP
      <?php
      /**
      * PHP version 5
      *
      * @category  Homebrew
      * @package   Homebrew_Test
      * @author    Homebrew <do.not@email.me>
      * @license   BSD Licence
      * @link      https://brew.sh/
      */
    PHP

    assert_match "FOUND 13 ERRORS", shell_output("#{bin}/phpcs --runtime-set ignore_errors_on_exit true test.php")
    assert_match "13 ERRORS WERE FIXED", shell_output("#{bin}/phpcbf test.php", 1)
    system bin/"phpcs", "test.php"
  end
end