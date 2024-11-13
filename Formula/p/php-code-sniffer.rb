class PhpCodeSniffer < Formula
  desc "Check coding standards in PHP, JavaScript and CSS"
  homepage "https:github.comPHPCSStandardsPHP_CodeSniffer"
  url "https:github.comPHPCSStandardsPHP_CodeSnifferreleasesdownload3.11.0phpcs.phar"
  sha256 "ac2c0ca12e27814ce0865b619425258c13f9c08046e58d11aed06c6712339fc2"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "dfba9b1ba91ba10623af8e43f660ff8ae4f675122da0a6b4943a15586e75ee73"
  end

  depends_on "php"

  resource "phpcbf.phar" do
    url "https:github.comPHPCSStandardsPHP_CodeSnifferreleasesdownload3.11.0phpcbf.phar"
    sha256 "7d3efd51ec43ed569f8e95db68ad296c030c51be7a3c0740f48be9b8497e1ad6"
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