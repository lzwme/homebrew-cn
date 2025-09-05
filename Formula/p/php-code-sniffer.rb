class PhpCodeSniffer < Formula
  desc "Check coding standards in PHP, JavaScript and CSS"
  homepage "https://github.com/PHPCSStandards/PHP_CodeSniffer"
  url "https://ghfast.top/https://github.com/PHPCSStandards/PHP_CodeSniffer/releases/download/3.13.3/phpcs.phar"
  sha256 "4f60d903d78151829ae04e9971db771e67e5d2007578dc9f30781080105e1a5b"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7ddbb69ae293cf744ff639876524e1459faf08d72b7ae93881202484b9058acb"
  end

  depends_on "php"

  resource "phpcbf.phar" do
    url "https://ghfast.top/https://github.com/PHPCSStandards/PHP_CodeSniffer/releases/download/3.13.3/phpcbf.phar"
    sha256 "1239e61060b51873b095a49fb674fcada07592421576b32b3e3fca6998d63896"

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